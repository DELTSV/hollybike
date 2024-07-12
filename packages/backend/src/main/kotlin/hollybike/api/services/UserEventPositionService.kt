package hollybike.api.services

import hollybike.api.json
import hollybike.api.repository.*
import hollybike.api.services.storage.StorageService
import hollybike.api.types.journey.*
import hollybike.api.types.websocket.*
import hollybike.api.types.websocket.UserReceivePosition
import hollybike.api.types.websocket.UserSendPosition
import hollybike.api.utils.search.SearchParam
import hollybike.api.utils.search.applyParam
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
import org.jetbrains.exposed.sql.*
import org.jetbrains.exposed.sql.SqlExpressionBuilder.eq
import org.jetbrains.exposed.sql.transactions.transaction
import kotlin.math.sqrt

class UserEventPositionService(
	private val db: Database,
	private val scope: CoroutineScope,
	private val storageService: StorageService
) {
	private val receiveChannels: MutableMap<Pair<Int, Int>, Channel<Body>> = mutableMapOf()

	private val sendChannels: MutableMap<Int, MutableSharedFlow<Body>> = mutableMapOf()

	val lastPosition: MutableMap<Int, MutableMap<Int, UserEventPosition>> = mutableMapOf()

	fun getSendChannel(eventId: Int): MutableSharedFlow<Body> {
		return sendChannels[eventId] ?: run {
			MutableSharedFlow<Body>(15, 15).apply { sendChannels[eventId] = this }
		}
	}

	private suspend fun sendPosition(eventId: Int, position: UserEventPosition) {
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

	private suspend fun sendStopPosition(eventId: Int, user: Int) {
		getSendChannel(eventId).emit(
			StopUserReceivePosition(user)
		)
	}

	suspend fun getReceiveChannel(eventId: Int, userId: Int): Channel<Body> {
		return receiveChannels[eventId to userId] ?: run {
			lastPosition[eventId] ?: run {
				lastPosition[eventId] = mutableMapOf()
			}
			Channel<Body>(Channel.BUFFERED).apply {
				scope.launch {
					listenChannel(eventId, userId)
				}
				receiveChannels[eventId to userId] = this
			}
		}
	}

	private suspend fun Channel<Body>.listenChannel(eventId: Int, userId: Int) {
		val event = transaction(db) { Event.findById(eventId) } ?: return
		val user = transaction(db) { User.findById(userId) } ?: return
		val participation = transaction(db) {
			EventParticipation.find {
				(EventParticipations.user eq user.id) and (EventParticipations.event eq event.id) and (EventParticipations.isJoined eq true)
			}.firstOrNull()
		} ?: return
		for (message in this) {
			println(message)
			if(message is UserSendPosition) {
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
				sendPosition(eventId, entity)
			} else if(message is StopUserSendPosition) {
				lastPosition[eventId]!!.remove(userId)
				sendStopPosition(eventId, userId)
			}
		}
	}

	fun getUserJourneyFromEvent(user: User, event: Event): UserJourney? = transaction(db) {
		val participation = EventParticipation.find {
			(EventParticipations.user eq user.id) and (EventParticipations.event eq event.id)
		}.firstOrNull()?.load(EventParticipation::journey) ?: return@transaction null
		participation.journey
	}

	fun removeUserJourneyFromEvent(user: User, event: Event) = transaction(db) {
		val participation = EventParticipation.find {
			(EventParticipations.user eq user.id) and (EventParticipations.event eq event.id)
		}.firstOrNull() ?: return@transaction

		participation.journey = null
	}

	suspend fun deleteUserJourney(userJourney: UserJourney) {
		transaction(db) { userJourney.delete() }
		storageService.delete(userJourney.journey)
	}

	fun getUserJourney(caller: User, userJourneyId: Int) = transaction(db) {
		UserJourney.find { (UsersJourneys.id eq userJourneyId) and (UsersJourneys.user eq caller.id) }.firstOrNull()
	}

	fun getUserJourneys(userId: Int, searchParams: SearchParam): List<UserJourney> = transaction(db) {
		UserJourney.wrapRows(
			UsersJourneys
				.selectAll()
				.where(UsersJourneys.user eq userId)
				.applyParam(searchParams)
		).toList()
	}

	fun countUserJourneys(userId: Int, searchParams: SearchParam): Long = transaction(db) {
		UsersJourneys
			.selectAll().where { UsersJourneys.user eq userId }
			.applyParam(searchParams, pagination = false)
			.count()
	}

	private fun calculatePercentage(value: Double, otherValues: List<Double>): Double {
		val countBetter = otherValues.count { it <= value }
		return (countBetter.toDouble() / otherValues.size.toDouble()) * 100
	}

	private fun getValueForKey(journey: UserJourney, key: String): Double? {
		return when (key) {
			"max_speed" -> journey.maxSpeed
			"avg_speed" -> journey.avgSpeed
			"min_elevation" -> journey.minElevation
			"max_elevation" -> journey.maxElevation
			"total_elevation_gain" -> journey.totalElevationGain
			"total_elevation_loss" -> journey.totalElevationLoss
			"avg_g_force" -> journey.avgGForce
			"max_g_force" -> journey.maxGForce
			else -> null
		}
	}

	fun getIsBetterThanForUserJourney(userJourney: UserJourney?): Map<String, Double> = transaction(db) {
		if (userJourney == null) {
			return@transaction emptyMap()
		}

		val participation = EventParticipation.find {
			(EventParticipations.journey eq userJourney.id) and (EventParticipations.isJoined eq true)
		}.firstOrNull()

		if (participation == null) {
			return@transaction emptyMap()
		}

		val eventId = participation.event.id.value

		val otherParticipations = EventParticipation.find {
			(EventParticipations.event eq eventId) and
				(EventParticipations.isJoined eq true) and
				(EventParticipations.id neq participation.id)
		}

		val othersJourneys = otherParticipations.mapNotNull { it.journey }

		if (othersJourneys.isEmpty()) {
			return@transaction emptyMap()
		}

		val hasBest = mutableMapOf<String, Double>()

		val valueMapping = mapOf(
			"max_speed" to userJourney.maxSpeed,
			"avg_speed" to userJourney.avgSpeed,
			"min_elevation" to userJourney.minElevation,
			"max_elevation" to userJourney.maxElevation,
			"total_elevation_gain" to userJourney.totalElevationGain,
			"total_elevation_loss" to userJourney.totalElevationLoss,
			"avg_g_force" to userJourney.avgGForce,
			"max_g_force" to userJourney.maxGForce
		)

		for ((key, value) in valueMapping) {
			value ?: continue

			val otherValues = othersJourneys.mapNotNull { getValueForKey(it, key) }
			hasBest[key] = calculatePercentage(value, otherValues)
		}

		hasBest
	}

	private fun calculateTotalAcceleration(
		accelerationX: Double,
		accelerationY: Double,
		accelerationZ: Double
	): Double = sqrt(accelerationX * accelerationX + accelerationY * accelerationY + accelerationZ * accelerationZ)

	private fun convertToGForce(acceleration: Double): Double = acceleration / 9.81

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
		var totalCount = 0
		var maxAcceleration = Double.NEGATIVE_INFINITY
		var totalAcceleration = 0.0

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

				val acceleration = calculateTotalAcceleration(pos.accelerationX, pos.accelerationY, pos.accelerationZ)

				if (acceleration > maxAcceleration) {
					maxAcceleration = acceleration
				}
				totalAcceleration += acceleration

				totalCount++
			}

			UsersEventsPositions.deleteWhere {
				(UsersEventsPositions.user eq user.id) and (UsersEventsPositions.event eq event.id)
			}
		}

		val avgSpeed = totalSpeed / totalCount
		val avgGForce = convertToGForce(totalAcceleration / totalCount)
		val maxGForce = convertToGForce(maxAcceleration)
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
				this.avgGForce = avgGForce
				this.maxGForce = maxGForce
				this.user = user
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