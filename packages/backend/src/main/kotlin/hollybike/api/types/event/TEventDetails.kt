package hollybike.api.types.event

import hollybike.api.repository.Event
import hollybike.api.repository.EventParticipation
import hollybike.api.types.event.participation.TEventCallerParticipation
import hollybike.api.types.event.participation.TEventParticipation
import hollybike.api.types.journey.TJourneyPartial
import kotlinx.serialization.Serializable

@Serializable
data class TEventDetails(
	val event: TEvent,
	val callerParticipation: TEventCallerParticipation?,
	val journey: TJourneyPartial?,
	val previewParticipants: List<TEventParticipation>,
	val previewParticipantsCount: Int,
) {
	constructor(
		event: Event,
		callerParticipation: EventParticipation?,
		participants: List<EventParticipation>,
		participantsCount: Int
	) : this(
		event = TEvent(event),
		callerParticipation = callerParticipation?.let { TEventCallerParticipation(it) },
		journey = event.journey?.let { TJourneyPartial(it) },
		previewParticipants = participants.map { TEventParticipation(it) },
		previewParticipantsCount = participantsCount
	)
}