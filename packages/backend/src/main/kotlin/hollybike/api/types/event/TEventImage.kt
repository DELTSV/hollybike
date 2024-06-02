package hollybike.api.types.event

import hollybike.api.repository.EventImage
import hollybike.api.types.user.TUserPartial
import kotlinx.serialization.Serializable

@Serializable
data class TEventImage(
	val id: Int,
	val owner: TUserPartial,
	val path: String,
	val size: Int,
	val uploadDateTime: String,
) {
	constructor(entity: EventImage, signer: (String) -> String) : this(
		id = entity.id.value,
		owner = TUserPartial(entity.owner, signer),
		path = signer(entity.path),
		size = entity.size,
		uploadDateTime = entity.uploadDateTime.toString()
	)
}