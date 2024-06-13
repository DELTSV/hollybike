package hollybike.api.types.position

data class PositionRequest(val latitude: Double, val longitude: Double, val scope: PositionScope)
