package hollybike.api.types.event

import kotlinx.serialization.Serializable

@Serializable
data class TAddJourneyToEvent(
	val journeyId: Int,
)
