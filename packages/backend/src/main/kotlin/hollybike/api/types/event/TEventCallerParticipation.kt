package hollybike.api.types.event

import hollybike.api.repository.EventParticipation
import kotlinx.datetime.Instant
import kotlinx.serialization.Serializable

@Serializable
data class TEventCallerParticipation(
	val role: EEventRole,
	val isImagesPublic: Boolean,
	val joinedDateTime: Instant,
) {
	constructor(entity: EventParticipation) : this(
		role = entity.role,
		isImagesPublic = entity.isImagesPublic,
		joinedDateTime = entity.joinedDateTime
	)
}
