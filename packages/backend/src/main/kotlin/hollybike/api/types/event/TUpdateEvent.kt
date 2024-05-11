package hollybike.api.types.event

import kotlinx.serialization.Serializable

@Serializable
data class TUpdateEvent(
	val name: String,
	val description: String? = null,
	val startDate: String,
	val endDate: String? = null
)
