/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.types.journey

import hollybike.api.repository.Journey
import hollybike.api.types.position.TPosition
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class TJourneyPartial(
	val id: Int,
	val name: String,
	val file: String? = null,
	@SerialName("preview_image")
	val previewImage: String? = null,
	@SerialName("preview_image_key")
	val previewImageKey: String? = null,
	val start: TPosition? = null,
	val end: TPosition? = null,
	val destination: TPosition? = null,
	val totalDistance: Int? = null,
	val minElevation: Double? = null,
	val maxElevation: Double? = null,
	val totalElevationGain: Double? = null,
	val totalElevationLoss: Double? = null
) {
	constructor(journey: Journey) : this(
		journey.id.value,
		journey.name,
		journey.signedFile,
		journey.signedPreviewImage,
		journey.previewImage,
		journey.start?.let { TPosition(it) },
		journey.end?.let { TPosition(it) },
		journey.destination?.let { TPosition(it) },
		journey.totalDistance,
		journey.minElevation,
		journey.maxElevation,
		journey.totalElevationGain,
		journey.totalElevationLoss
	)
}
