package hollybike.api.types.journey

import kotlinx.serialization.Serializable

@Serializable
data class TNewJourney(
	val name: String,
	val association: Int? = null
)
