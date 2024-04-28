package hollybike.api.types.event

import hollybike.api.repository.User
import hollybike.api.repository.events.Event
import kotlinx.datetime.Instant
import hollybike.api.types.association.TAssociation
import hollybike.api.types.user.TUser
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class TEvent(
	val id: Int,
	val name: String,
	val description: String,
	val association: TAssociation,
	val image: String? = null,
	val status: EEventStatus,
	val owner: TUser,
	@SerialName("start_date_time")
	val startDateTime: Instant,
	@SerialName("end_date_time")
	val endDateTime: Instant? = null,
	@SerialName("create_date_time")
	val createDateTime: Instant,
	@SerialName("update_date_time")
	val updateDateTime: Instant,
) {
	constructor(entity: Event) : this(
		id = entity.id.value,
		name = entity.name,
		description = entity.description,
		association = TAssociation(entity.association),
		image = entity.image,
		status = entity.status,
		owner = TUser(entity.owner),
		startDateTime = entity.startDateTime,
		endDateTime = entity.endDateTime,
		createDateTime = entity.createDateTime,
		updateDateTime = entity.updateDateTime
	)
}
