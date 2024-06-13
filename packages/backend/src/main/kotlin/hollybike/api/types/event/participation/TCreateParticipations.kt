package hollybike.api.types.event.participation

import kotlinx.serialization.Serializable

@Serializable
data class TCreateParticipations(
	val userIds: List<Int>
)