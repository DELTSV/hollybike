/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.types.event

import hollybike.api.repository.Event
import hollybike.api.repository.EventParticipation
import hollybike.api.repository.Expense
import hollybike.api.types.event.participation.TEventCallerParticipation
import hollybike.api.types.event.participation.TEventParticipation
import hollybike.api.types.expense.TExpense
import hollybike.api.types.journey.TJourneyPartial
import kotlinx.serialization.Serializable

@Serializable
data class TEventDetails(
	val event: TEvent,
	val callerParticipation: TEventCallerParticipation?,
	val journey: TJourneyPartial?,
	val previewParticipants: List<TEventParticipation>,
	val previewParticipantsCount: Long,
	val expenses: List<TExpense>? = null,
	val totalExpense: Int? = null
) {
	constructor(
		event: Event,
		callerParticipation: EventParticipation?,
		participants: List<EventParticipation>,
		participantsCount: Long,
		expenses: List<Expense>?,
		isBetterThan: Map<String, Double>?
	) : this(
		event = TEvent(event, expenses != null),
		callerParticipation = callerParticipation?.let { TEventCallerParticipation(it, isBetterThan) },
		journey = event.journey?.let { TJourneyPartial(it) },
		previewParticipants = participants.map { TEventParticipation(it, emptyMap()) },
		previewParticipantsCount = participantsCount,
		expenses = expenses?.map { TExpense(it) },
		totalExpense = expenses?.sumOf { it.amount }
	)
}