package hollybike.api.types.position

import hollybike.api.repository.Position

data class PositionResponse(val topic: String, val identifier: Int, val content: Position)
