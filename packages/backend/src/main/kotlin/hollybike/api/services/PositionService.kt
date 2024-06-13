package hollybike.api.services

import hollybike.api.types.position.PositionRequest
import hollybike.api.types.position.PositionData
import hollybike.api.types.position.PositionMessage
import hollybike.api.types.position.PositionResponse
import kotlinx.coroutines.*
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.filter

class PositionService(private val scope: CoroutineScope) {
	private val messageChannel = Channel<PositionMessage>()
	private val subscribers = MutableSharedFlow<PositionResponse>(replay = 0)

	init {
		scope.launch {
			while (isActive) {
				delay(1200L)
				val message = messageChannel.tryReceive().getOrNull()
				if (message != null) {
					processMessage(message)
				}
			}
		}
	}

	fun push(topic: String, identifier: Int, content: PositionRequest) {
		val message = PositionMessage(topic, identifier, content)
		scope.launch {
			messageChannel.send(message)
		}
	}

	fun subscribe(topic: String, consumer: (PositionResponse) -> Unit) {
		scope.launch {
			subscribers
				.filter { it.topic == topic }
				.collect { positionData ->
					consumer(positionData)
				}
		}
	}

	private fun processMessage(message: PositionMessage) {
		scope.launch {
			val positionData = getPositionData(message.content)
			subscribers.emit(PositionResponse(message.topic, message.identifier, positionData))
		}
	}

	private fun getPositionData(positionRequest: PositionRequest): PositionData {
		val city = "DummyCity"
		return PositionData(city)
	}
}