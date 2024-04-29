package hollybike.api.types.event

import TUserPartial
import hollybike.api.repository.events.Event
import kotlinx.datetime.Instant
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class TEventPartial(
	val id: Int,
	val name: String,
	val description: String?,
	val image: String? = null,
	val status: EEventStatus,
	val owner: TUserPartial,
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
		image = entity.image,
		status = entity.status,
		owner = TUserPartial(entity.owner),
		startDateTime = entity.startDateTime,
		endDateTime = entity.endDateTime,
		createDateTime = entity.createDateTime,
		updateDateTime = entity.updateDateTime
	)
}
