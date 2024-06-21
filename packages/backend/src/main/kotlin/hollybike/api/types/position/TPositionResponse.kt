package hollybike.api.types.position

import hollybike.api.repository.Position

sealed class TPositionResult {
	abstract val topic: String
	abstract val identifier: Int

	data class Success(override var topic: String, override var identifier: Int, val position: Position) : TPositionResult()
	data class Error(override var topic: String, override var identifier: Int, val message: String) : TPositionResult()
}