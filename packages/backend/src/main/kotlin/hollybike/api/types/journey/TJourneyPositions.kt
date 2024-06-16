package hollybike.api.types.journey

import hollybike.api.repository.Journey
import hollybike.api.types.position.TPositionResponse
import kotlinx.datetime.Clock
import kotlinx.datetime.Instant

data class TJourneyPositions(
	val journey: Journey,
	val haveEnd: Boolean,
	var start: TPositionResponse? = null,
	var end: TPositionResponse? = null,
	val askedAt: Instant = Clock.System.now()
)
