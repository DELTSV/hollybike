package hollybike.api.types.event

import TUserPartial
import hollybike.api.repository.events.Event
import hollybike.api.repository.events.participations.EventParticipation
import kotlinx.datetime.Instant
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class TEvent(
	val id: Int,
	val name: String,
	val description: String?,
	val image: String?,
	val status: EEventStatus,
	val owner: TUserPartial,
	val participants: List<TEventParticipation>,
	@SerialName("start_date_time")
	val startDateTime: Instant,
	@SerialName("end_date_time")
	val endDateTime: Instant?,
	@SerialName("create_date_time")
	val createDateTime: Instant,
	@SerialName("update_date_time")
	val updateDateTime: Instant,
) {
	constructor(entity: Event, host: String, participants: List<EventParticipation> = entity.participants.toList()) : this(
		id = entity.id.value,
		name = entity.name,
		description = entity.description,
		image = entity.image?.let { "$host/storage/${it}" },
		status = EEventStatus.fromEvent(entity),
		owner = TUserPartial(entity.owner),
		participants = participants.map { TEventParticipation(it) },
		startDateTime = entity.startDateTime,
		endDateTime = entity.endDateTime,
		createDateTime = entity.createDateTime,
		updateDateTime = entity.updateDateTime
	)
}
