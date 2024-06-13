package hollybike.api.types.event.image

import kotlinx.serialization.Serializable

@Serializable
data class TUpdateImagesVisibility(
	val isImagesPublic: Boolean
)