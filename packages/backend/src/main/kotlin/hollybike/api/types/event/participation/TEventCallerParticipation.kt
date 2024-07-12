package hollybike.api.types.event.participation

import hollybike.api.repository.EventParticipation
import kotlinx.datetime.Instant
import kotlinx.serialization.Serializable

@Serializable
data class TEventCallerParticipation(
	val role: EEventRole,
	val userId: Int,
	val isImagesPublic: Boolean,
	val joinedDateTime: Instant,
	val journey: TUserJourney? = null,
	val hasRecordedPositions: Boolean
) {
	constructor(entity: EventParticipation, isBetterThan: Map<String, Double>?) : this(
		role = entity.role,
		userId = entity.user.id.value,
		isImagesPublic = entity.isImagesPublic,
		joinedDateTime = entity.joinedDateTime,
		journey = entity.journey?.let { TUserJourney(it, isBetterThan) },
		hasRecordedPositions = entity.hasRecordedPositions
	)
}
