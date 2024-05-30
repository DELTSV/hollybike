package hollybike.api.types.event

import kotlinx.serialization.Serializable

@Serializable
data class TUpdateImagesVisibility(
	val isImagesPublic: Boolean
)