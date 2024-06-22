package hollybike.api.services

import hollybike.api.repository.Event
import hollybike.api.repository.User
import hollybike.api.repository.UserEventPosition
import hollybike.api.types.websocket.UserReceivePosition
import hollybike.api.types.websocket.UserSendPosition
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.launch
import org.jetbrains.exposed.dao.load
import org.jetbrains.exposed.sql.Database
import org.jetbrains.exposed.sql.transactions.transaction

class UserEventPositionService(
	private val db: Database,
	private val scope: CoroutineScope
) {
	private val receiveChannels: MutableMap<Pair<Int, Int>, Channel<UserSendPosition>> = mutableMapOf()
	
	private val sendChannels: MutableMap<Int, Channel<UserReceivePosition>> = mutableMapOf()

	fun getSendChannel(eventId: Int): Channel<UserReceivePosition> {
		return sendChannels[eventId] ?: run {
			Channel<UserReceivePosition>(Channel.BUFFERED).apply { sendChannels[eventId] = this }
		}
	}

	private suspend fun send(eventId: Int, position: UserEventPosition) {
		getSendChannel(eventId).send(
			UserReceivePosition(
			position.latitude,
			position.longitude,
			position.altitude,
			position.time,
			position.user.id.value
		)
		)
	}

	suspend fun getReceiveChannel(eventId: Int, userId: Int) : Channel<UserSendPosition> {
		return receiveChannels[eventId to userId] ?: run {
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
		for(message in this) {
			val entity = transaction(db) {
				transaction(db) {
					UserEventPosition.new {
						this.user = user
						this.event = event
						this.latitude = message.latitude
						this.longitude = message.latitude
						this.altitude = message.altitude
						this.time = message.time
					}
				}.load(UserEventPosition::user)
			}
			send(eventId, entity)
		}
	}
}