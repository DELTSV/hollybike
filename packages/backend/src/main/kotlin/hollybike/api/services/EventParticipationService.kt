package hollybike.api.services

import hollybike.api.exceptions.AlreadyParticipatingToEventException
import hollybike.api.exceptions.EventActionDeniedException
import hollybike.api.exceptions.EventNotFoundException
import hollybike.api.exceptions.NotParticipatingToEventException
import hollybike.api.repository.*
import hollybike.api.types.event.EEventRole
import io.ktor.server.application.*
import org.jetbrains.exposed.dao.with
import org.jetbrains.exposed.sql.Database
import org.jetbrains.exposed.sql.and
import org.jetbrains.exposed.sql.transactions.transaction

class EventParticipationService(
	private val db: Database,
	private val eventService: EventService
) {
	suspend fun handleEventExceptions(exception: Throwable, call: ApplicationCall) =
		eventService.handleEventExceptions(exception, call)

	fun participateEvent(caller: User, eventId: Int): Result<EventParticipation> = transaction(db) {
		Event.find {
			Events.id eq eventId and eventService.eventUserCondition(caller)
		}.firstOrNull() ?: return@transaction Result.failure(EventNotFoundException("Event $eventId introuvable"))

		EventParticipation.find {
			(EventParticipations.user eq caller.id) and (EventParticipations.event eq eventId)
		}.firstOrNull()?.let {
			return@transaction Result.failure(AlreadyParticipatingToEventException("Vous participez déjà à cet événement"))
		}

		Result.success(
			EventParticipation.new {
				user = caller
				event = Event[eventId]
				role = EEventRole.Member
			}
		)
	}

	fun leaveEvent(caller: User, eventId: Int): Result<Unit> = transaction(db) {
		val event = Event.find {
			Events.id eq eventId and eventService.eventUserCondition(caller)
		}.firstOrNull() ?: return@transaction Result.failure(EventNotFoundException("Event $eventId introuvable"))

		if (event.owner.id == caller.id) {
			return@transaction Result.failure(EventActionDeniedException("Le propriétaire ne peut pas quitter l'événement"))
		}

		Result.success(
			EventParticipation.find {
				(EventParticipations.user eq caller.id) and (EventParticipations.event eq eventId)
			}.firstOrNull()?.delete()
				?: return@transaction Result.failure(NotParticipatingToEventException("Vous ne participez pas à cet événement"))
		)
	}

	fun promoteParticipant(caller: User, eventId: Int, userId: Int): Result<EventParticipation> {
		if (caller.id.value == userId) {
			return Result.failure(EventActionDeniedException("Vous ne pouvez pas vous promouvoir"))
		}

		return transaction(db) {
			Event.find {
				Events.id eq eventId and eventService.eventUserCondition(caller)
			}.firstOrNull() ?: return@transaction Result.failure(EventNotFoundException("Event $eventId introuvable"))

			EventParticipation.find {
				(EventParticipations.user eq caller.id) and (EventParticipations.event eq eventId)
			}.firstOrNull()?.apply {
				if (role != EEventRole.Organizer) {
					return@transaction Result.failure(EventActionDeniedException("Seul l'organisateur peut promouvoir un participant"))
				}
			}
				?: return@transaction Result.failure(NotParticipatingToEventException("Vous ne participez pas à cet événement"))

			Result.success(
				EventParticipation.find {
					(EventParticipations.user eq userId) and (EventParticipations.event eq eventId)
				}.with(EventParticipation::user).firstOrNull()?.apply {
					if (role == EEventRole.Member) {
						role = EEventRole.Organizer
					} else {
						return@transaction Result.failure(EventActionDeniedException("Seul un membre peut être promu"))
					}
				}
					?: return@transaction Result.failure(NotParticipatingToEventException("L'utilisateur ne participe pas à cet événement"))
			)
		}
	}

	fun demoteParticipant(caller: User, eventId: Int, userId: Int): Result<EventParticipation> {
		if (caller.id.value == userId) {
			return Result.failure(EventActionDeniedException("Vous ne pouvez pas vous rétrograder"))
		}

		return transaction(db) {
			Event.find {
				Events.id eq eventId and eventService.eventUserCondition(caller)
			}.firstOrNull() ?: return@transaction Result.failure(EventNotFoundException("Event $eventId introuvable"))

			EventParticipation.find {
				(EventParticipations.user eq caller.id) and (EventParticipations.event eq eventId)
			}.firstOrNull()?.apply {
				if (role != EEventRole.Organizer) {
					return@transaction Result.failure(EventActionDeniedException("Seul l'organisateur peut rétrograder un participant"))
				}
			}
				?: return@transaction Result.failure(NotParticipatingToEventException("Vous ne participez pas à cet événement"))

			Result.success(
				EventParticipation.find {
					(EventParticipations.user eq userId) and (EventParticipations.event eq eventId)
				}.with(EventParticipation::user).firstOrNull()?.apply {
					if (role == EEventRole.Organizer) {
						role = EEventRole.Member
					} else {
						return@transaction Result.failure(EventActionDeniedException("Seul un organisateur peut être rétrogradé"))
					}
				}
					?: return@transaction Result.failure(NotParticipatingToEventException("L'utilisateur ne participe pas à cet événement"))
			)
		}
	}
}