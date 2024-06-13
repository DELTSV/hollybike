package hollybike.api.types.position

data class PositionMessage(val topic: String, val identifier: Int, val content: PositionRequest)
