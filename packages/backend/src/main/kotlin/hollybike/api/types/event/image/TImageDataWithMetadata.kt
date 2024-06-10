package hollybike.api.types.event.image

class TImageDataWithMetadata(
	val data: ByteArray,
	val contentType: String,
	val metadata: TImageMetadata
)
