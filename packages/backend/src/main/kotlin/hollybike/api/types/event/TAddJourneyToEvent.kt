package hollybike.api.types.event

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class TAddJourneyToEvent(
	@SerialName("journey_id")
	val journeyId: Int,
)
