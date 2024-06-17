package hollybike.api.types.journey

import hollybike.api.repository.Journey
import hollybike.api.types.position.TPosition
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class TJourneyPartial(
	val file: String? = null,
	@SerialName("preview_image")
	val previewImage: String? = null,
	val start: TPosition? = null,
	val end: TPosition? = null
) {
	constructor(journey: Journey) : this(
		journey.signedFile,
		journey.signedPreviewImage,
		journey.start?.let { TPosition(it) },
		journey.end?.let { TPosition(it) }
	)
}
