package hollybike.api.types.position

data class TPositionMessage(val topic: String, val identifier: Int, val content: TPositionRequest)
