package hollybike.api.types.position

data class PositionResponse(val topic: String, val identifier: Int, val content: PositionData)
