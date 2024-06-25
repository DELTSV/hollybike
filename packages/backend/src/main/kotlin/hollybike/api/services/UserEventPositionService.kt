package hollybike.api.services

import hollybike.api.repository.*
import hollybike.api.types.journey.Feature
import hollybike.api.types.journey.GeoJson
import hollybike.api.types.journey.GeoJsonCoordinates
import hollybike.api.types.journey.LineString
import hollybike.api.types.websocket.UserReceivePosition
import hollybike.api.types.websocket.UserSendPosition
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.launch
import kotlinx.serialization.json.JsonArray
import kotlinx.serialization.json.JsonObject
import kotlinx.serialization.json.JsonPrimitive
import org.jetbrains.exposed.dao.load
import org.jetbrains.exposed.sql.Database
import org.jetbrains.exposed.sql.and
import org.jetbrains.exposed.sql.transactions.transaction

class UserEventPositionService(
	private val db: Database,
	private val scope: CoroutineScope
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
		for (message in this) {
			val entity = transaction(db) {
				transaction(db) {
					UserEventPosition.new {
						this.user = user
						this.event = event
						this.latitude = message.latitude
						this.longitude = message.latitude
						this.altitude = message.altitude
						this.time = message.time
						this.speed = message.speed
					}
				}.load(UserEventPosition::user)
			}
			lastPosition[eventId]!![userId] = entity
			send(eventId, entity)
		}
	}

	fun retrieveUserJourney(user: User, event: Event): GeoJson {
		val coord = mutableListOf<GeoJsonCoordinates>()
		val times = mutableListOf<JsonPrimitive>()
		val speed = mutableListOf<JsonPrimitive>()
		transaction(db) {
			UserEventPosition.find { (UsersEventsPositions.user eq user.id) and (UsersEventsPositions.event eq event.id) }.forEach { pos ->
				coord.add(listOf(pos.latitude, pos.longitude, pos.altitude))
				times.add(JsonPrimitive(pos.time.toString()))
				speed.add(JsonPrimitive(pos.speed))
				pos.delete()
			}
		}
		return Feature(
			geometry = LineString(coord),
			properties = JsonObject(
				mapOf(
					"coordTimes" to JsonArray(times),
					"speed" to JsonArray(speed)
				)
			)
		)
	}
}