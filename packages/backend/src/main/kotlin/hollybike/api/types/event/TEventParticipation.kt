package hollybike.api.types.event

import hollybike.api.types.user.TUserPartial
import hollybike.api.repository.events.participations.EventParticipation
import kotlinx.datetime.Instant
import kotlinx.serialization.Serializable

@Serializable
data class TEventParticipation(
	val user: TUserPartial,
	val role: EEventRole,
	val joinedDateTime: Instant,
) {
	constructor(entity: EventParticipation, signer: (String) -> String) : this(
		user = TUserPartial(entity.user, signer),
		role = entity.role,
		joinedDateTime = entity.joinedDateTime
	)
}
