package hollybike.api.types.journey

import hollybike.api.repository.Journey
import hollybike.api.types.association.TPartialAssociation
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
	val association: TPartialAssociation
) {
	constructor(journey: Journey) : this(
		journey.id.value,
		journey.name,
		journey.file,
		journey.createdAt,
		TUserPartial(journey.creator),
		TPartialAssociation(journey.association)
	)
}
