package hollybike.api.services

import hollybike.api.json
import hollybike.api.repository.*
import hollybike.api.services.storage.StorageService
import hollybike.api.types.journey.*
import hollybike.api.types.websocket.UserReceivePosition
import hollybike.api.types.websocket.UserSendPosition
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.launch
import kotlinx.datetime.Instant
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.JsonArray
import kotlinx.serialization.json.JsonObject
import kotlinx.serialization.json.JsonPrimitive
import org.jetbrains.exposed.dao.load
import org.jetbrains.exposed.sql.Database
import org.jetbrains.exposed.sql.SortOrder
import org.jetbrains.exposed.sql.SqlExpressionBuilder.eq
import org.jetbrains.exposed.sql.and
import org.jetbrains.exposed.sql.deleteWhere
import org.jetbrains.exposed.sql.transactions.transaction

class UserEventPositionService(
	private val db: Database,
	private val scope: CoroutineScope,
	private val storageService: StorageService
) {
	private val receiveChannels: MutableMap<Pair<Int, Int>, Channel<UserSendPosition>> = mutableMapOf()

	private val sendChannels: MutableMap<Int, MutableSharedFlow<UserReceivePosition>> = mutableMapOf()

	val lastPosition: MutableMap<Int, MutableMap<Int, UserEventPosition>> = mutableMapOf()

	fun getSendChannel(eventId: Int): MutableSharedFlow<UserReceivePosition> {
		return sendChannels[eventId] ?: run {
			MutableSharedFlow<UserReceivePosition>(15, 15).apply { sendChannels[eventId] = this }
		}
	}

	private suspend fun send(eventId: Int, position: UserEventPosition) {
		getSendChannel(eventId).emit(
			UserReceivePosition(
				position.latitude,
				position.longitude,
				position.altitude,
				position.time,
				position.speed,
				position.user.id.value
			)
		)
	}

	suspend fun getReceiveChannel(eventId: Int, userId: Int): Channel<UserSendPosition> {
		return receiveChannels[eventId to userId] ?: run {
			lastPosition[eventId] ?: run {
				lastPosition[eventId] = mutableMapOf()
			}
			Channel<UserSendPosition>(Channel.BUFFERED).apply {
				scope.launch {
					listenChannel(eventId, userId)
				}
				receiveChannels[eventId to userId] = this
			}
		}
	}

	private suspend fun Channel<UserSendPosition>.listenChannel(eventId: Int, userId: Int) {
		val event = transaction(db) { Event.findById(eventId) } ?: return
		val user = transaction(db) { User.findById(userId) } ?: return
		val participation = transaction(db) {
			EventParticipation.find {
				(EventParticipations.user eq user.id) and (EventParticipations.event eq event.id) and (EventParticipations.isJoined eq true)
			}.firstOrNull()
		} ?: return
		for (message in this) {
			val entity = transaction(db) {
				transaction(db) {
					UserEventPosition.new {
						this.user = user
						this.event = event
						this.participation = participation
						this.latitude = message.latitude
						this.longitude = message.longitude
						this.altitude = message.altitude
						this.time = message.time
						this.speed = message.speed
						this.heading = message.heading
						this.accelerationX = message.accelerationX
						this.accelerationY = message.accelerationY
						this.accelerationZ = message.accelerationZ
						this.accuracy = message.accuracy
						this.speedAccuracy = message.speedAccuracy
					}
				}.load(UserEventPosition::user)
			}
			lastPosition[eventId]!![userId] = entity
			send(eventId, entity)
		}
	}

	fun getUserJourney(user: User, event: Event): UserJourney? = transaction(db) {
		val participation = EventParticipation.find {
			(EventParticipations.user eq user.id) and (EventParticipations.event eq event.id)
		}.firstOrNull()?.load(EventParticipation::journey) ?: return@transaction null
		participation.journey
	}

	suspend fun terminateUserJourney(user: User, event: Event): UserJourney {
		val coord = mutableListOf<GeoJsonCoordinates>()
		val times = mutableListOf<JsonPrimitive>()
		val speed = mutableListOf<JsonPrimitive>()
		var elevationGain = 0.0
		var elevationLoss = 0.0
		var minElevation = Double.POSITIVE_INFINITY
		var maxElevation = Double.NEGATIVE_INFINITY
		var prevAltitude: Double? = null
		var maxSpeed = Double.NEGATIVE_INFINITY
		var totalSpeed = 0.0
		var totalSpeedCount = 0

		transaction(db) {
			UserEventPosition.find {
				(UsersEventsPositions.user eq user.id) and
					(UsersEventsPositions.event eq event.id) and
					(UsersEventsPositions.accuracy lessEq 20.0)
			}.orderBy(UsersEventsPositions.time to SortOrder.ASC).forEach { pos ->
				coord.add(listOf(pos.longitude, pos.latitude, pos.altitude))
				times.add(JsonPrimitive(pos.time.toString()))
				speed.add(JsonPrimitive(pos.speed))

				if (pos.altitude < (prevAltitude ?: pos.altitude)) {
					elevationLoss += (prevAltitude ?: pos.altitude) - pos.altitude
				} else {
					elevationGain += pos.altitude - (prevAltitude ?: pos.altitude)
				}
				prevAltitude = pos.altitude

				if (pos.altitude < minElevation) {
					minElevation = pos.altitude
				}
				if (pos.altitude > maxElevation) {
					maxElevation = pos.altitude
				}

				if (pos.speed > maxSpeed) {
					maxSpeed = pos.speed
				}
				totalSpeed += pos.speed
				totalSpeedCount++
			}

			UsersEventsPositions.deleteWhere {
				(UsersEventsPositions.user eq user.id) and (UsersEventsPositions.event eq event.id)
			}
		}

		val avgSpeed = totalSpeed / totalSpeedCount
		val totalTime = (Instant.parse(times.last().content) - Instant.parse(times.first().content)).inWholeSeconds
		val geojson = Feature(
			geometry = LineString(coord),
			properties = JsonObject(
				mapOf(
					"coordTimes" to JsonArray(times),
					"speed" to JsonArray(speed)
				)
			)
		)

		val file = uploadUserJourney(geojson, event.id.value, user.id.value)

		return transaction(db) {
			val participation = EventParticipation.find {
				(EventParticipations.user eq user.id) and (EventParticipations.event eq event.id)
			}.first()
			UserJourney.new {
				this.journey = file
				this.avgSpeed = avgSpeed
				this.totalElevationGain = elevationGain
				this.totalElevationLoss = elevationLoss
				this.totalDistance = calculateDistance(coord)
				this.minElevation = minElevation
				this.maxElevation = maxElevation
				this.totalTime = totalTime
				this.maxSpeed = maxSpeed
			}.apply {
				participation.journey = this
			}
		}
	}

	private suspend fun uploadUserJourney(geoJson: GeoJson, eventId: Int, userId: Int): String {
		val json = json.encodeToString(geoJson).toByteArray()
		val path = "e/$eventId/u/$userId/j"
		storageService.store(json, path, "application/geo+json")
		return path
	}
}