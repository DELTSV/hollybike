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
	constructor(entity: EventImage, signer: (String) -> String) : this(
		id = entity.id.value,
		url = signer(entity.path),
		size = entity.size,
		width = entity.width,
		height = entity.height,
	)
}