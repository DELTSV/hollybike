package hollybike.api.types.event.image

import kotlinx.serialization.Serializable

@Serializable
data class TImagePositionMetadata(
	val latitude: Double,
	val longitude: Double,
	val altitude: Int?,
)
