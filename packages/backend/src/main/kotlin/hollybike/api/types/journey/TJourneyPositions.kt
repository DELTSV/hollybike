package hollybike.api.types.journey

import hollybike.api.repository.Journey
import hollybike.api.repository.Position
import kotlinx.datetime.Clock
import kotlinx.datetime.Instant

data class TJourneyPositions(
	val journey: Journey,
	val haveEnd: Boolean,
	val haveDestination: Boolean,
	var start: Position? = null,
	var end: Position? = null,
	var destination: Position? = null,
	val askedAt: Instant = Clock.System.now()
)
