package hollybike.api.types.position

import hollybike.api.repository.EventImage
import hollybike.api.types.event.image.TImageMetadata

class TImageForProcessing(
	val entity: EventImage,
	val contentType: String,
	val data: ByteArray,
	val position: TImageMetadata.Position?
)