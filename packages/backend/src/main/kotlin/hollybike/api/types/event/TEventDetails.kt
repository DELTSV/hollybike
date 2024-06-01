package hollybike.api.types.event

import hollybike.api.repository.Event
import hollybike.api.repository.EventParticipation
import kotlinx.serialization.Serializable

@Serializable
data class TEventDetails(
	val event: TEvent,
	val previewParticipants: List<TEventParticipation>,
	val previewParticipantsCount: Int,
) {
	constructor(
		event: Event,
		participants: List<EventParticipation>,
		participantsCount: Int,
		signer: (String) -> String,
	) : this(
		event = TEvent(event, signer),
		previewParticipants = participants.map { TEventParticipation(it, signer) },
		previewParticipantsCount = participantsCount
	)
}