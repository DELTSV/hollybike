package hollybike.api.types.event

import kotlinx.serialization.Serializable

@Serializable
data class TCreateParticipations(
	val userIds: List<Int>
)