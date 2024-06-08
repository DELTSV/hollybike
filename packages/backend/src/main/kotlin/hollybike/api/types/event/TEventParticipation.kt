package hollybike.api.types.event

import hollybike.api.repository.EventParticipation
import hollybike.api.types.user.TUserPartial
import kotlinx.datetime.Instant
import kotlinx.serialization.Serializable

@Serializable
data class TEventParticipation(
	val user: TUserPartial,
	val role: EEventRole,
	val isImagesPublic: Boolean,
	val joinedDateTime: Instant,
) {
	constructor(entity: EventParticipation) : this(
		user = TUserPartial(entity.user),
		role = entity.role,
		isImagesPublic = entity.isImagesPublic,
		joinedDateTime = entity.joinedDateTime
	)
}
