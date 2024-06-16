package hollybike.api.types.journey

import hollybike.api.repository.Journey
import hollybike.api.types.association.TPartialAssociation
import hollybike.api.types.position.TPosition
import hollybike.api.types.user.TUserPartial
import kotlinx.datetime.Instant
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class TJourney(
	val id: Int,
	val name: String,
	val file: String? = null,
	@SerialName("created_at")
	val createdAt: Instant,
	val creator: TUserPartial,
	val association: TPartialAssociation,
	val start: TPosition? = null,
	val end: TPosition? = null
) {
	constructor(journey: Journey) : this(
		journey.id.value,
		journey.name,
		journey.signedFile,
		journey.createdAt,
		TUserPartial(journey.creator),
		TPartialAssociation(journey.association),
		journey.start?.let { TPosition(it) },
		journey.end?.let { TPosition(it) }
	)
}
