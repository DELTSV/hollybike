package hollybike.api.types.journey

import hollybike.api.repository.Journey
import hollybike.api.types.position.TPosition
import kotlinx.serialization.Serializable

@Serializable
data class TJourneyPartial(
	val file: String? = null,
	val start: TPosition? = null,
	val end: TPosition? = null
) {
	constructor(journey: Journey) : this(
		journey.signedFile,
		journey.start?.let { TPosition(it) },
		journey.end?.let { TPosition(it) }
	)
}
