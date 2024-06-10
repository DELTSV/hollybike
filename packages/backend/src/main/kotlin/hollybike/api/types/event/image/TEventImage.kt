package hollybike.api.types.event.image

import hollybike.api.repository.EventImage
import hollybike.api.types.user.TUserPartial
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class TEventImage(
	val id: Int,
	val owner: TUserPartial,
	val url: String,
	val size: Int,
	@SerialName("upload_date_time")
	val uploadDateTime: String,
) {
	constructor(entity: EventImage, signer: (String) -> String) : this(
		id = entity.id.value,
		owner = TUserPartial(entity.owner, signer),
		url = signer(entity.path),
		size = entity.size,
		uploadDateTime = entity.uploadDateTime.toString()
	)
}