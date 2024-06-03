package hollybike.api.types.event

import hollybike.api.repository.EventParticipation
import kotlinx.datetime.Instant
import kotlinx.serialization.Serializable

@Serializable
data class TEventCallerParticipation(
	val role: EEventRole,
	val isOwner: Boolean,
	val isImagesPublic: Boolean,
	val joinedDateTime: Instant,
) {
	constructor(entity: EventParticipation, isOwner: Boolean) : this(
		role = entity.role,
		isOwner = isOwner,
		isImagesPublic = entity.isImagesPublic,
		joinedDateTime = entity.joinedDateTime
	)
}
