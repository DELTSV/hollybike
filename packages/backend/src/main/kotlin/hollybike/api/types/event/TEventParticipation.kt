package hollybike.api.types.event

import TUserPartial
import hollybike.api.repository.events.participations.EventParticipation
import kotlinx.datetime.Instant
import kotlinx.serialization.Serializable

@Serializable
data class TEventParticipation(
	val user: TUserPartial,
	val role: EEventRole,
	val joinedDateTime: Instant,
) {
	constructor(entity: EventParticipation) : this(
		user = TUserPartial(entity.user),
		role = entity.role,
		joinedDateTime = entity.joinedDateTime
	)
}
