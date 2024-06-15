package hollybike.api.types.event.image

import hollybike.api.repository.EventImage
import kotlinx.serialization.Serializable

@Serializable
data class TEventImage(
	val id: Int,
	val url: String,
	val size: Int,
	val width: Int,
	val height: Int,
) {
	constructor(entity: EventImage) : this(
		id = entity.id.value,
		url = entity.signedPath,
		size = entity.size,
		width = entity.width,
		height = entity.height,
	)
}