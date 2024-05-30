package hollybike.api.services

import hollybike.api.exceptions.AlreadyParticipatingToEventException
import hollybike.api.exceptions.EventActionDeniedException
import hollybike.api.exceptions.EventNotFoundException
import hollybike.api.exceptions.NotParticipatingToEventException
import hollybike.api.repository.*
import hollybike.api.types.event.EEventRole
import hollybike.api.utils.search.SearchParam
import hollybike.api.utils.search.applyParam
import io.ktor.server.application.*
import kotlinx.datetime.Clock
import org.jetbrains.exposed.dao.with
import org.jetbrains.exposed.sql.*
import org.jetbrains.exposed.sql.SqlExpressionBuilder.eq
import org.jetbrains.exposed.sql.transactions.transaction

class EventParticipationService(
	private val db: Database,
	private val eventService: EventService
) {
	suspend fun handleEventExceptions(exception: Throwable, call: ApplicationCall) =
		eventService.handleEventExceptions(exception, call)

	private fun eventParticipationUserEventCondition(caller: User, event: Event): Op<Boolean> =
		EventParticipations.run {
			(user eq caller.id) and eventParticipationCondition(event)
		}

	private fun eventParticipationCondition(event: Event): Op<Boolean> = EventParticipations.run {
		(this.event eq event.id) and (isJoined eq true)
	}

	fun getEventParticipations(caller: User, eventId: Int, searchParam: SearchParam): Result<List<EventParticipation>> =
		transaction(db) {
			val event = Event.find {
				Events.id eq eventId and eventService.eventUserCondition(caller)
			}.firstOrNull() ?: return@transaction Result.failure(EventNotFoundException("Event $eventId introuvable"))

			Result.success(
				EventParticipation.wrapRows(
					EventParticipations.innerJoin(Events, { this.event }, { Events.id })
						.selectAll()
						.applyParam(searchParam)
						.andWhere { eventService.eventUserCondition(caller) and eventParticipationCondition(event) }
				).with(EventParticipation::user).toList()
			)
		}

	fun getEventCount(caller: User, eventId: Int): Result<Int> = transaction(db) {
		val event = Event.find {
			Events.id eq eventId and eventService.eventUserCondition(caller)
		}.firstOrNull() ?: return@transaction Result.failure(EventNotFoundException("Event $eventId introuvable"))

		Result.success(
			EventParticipation.find {
				eventParticipationCondition(event)
			}.count().toInt()
		)
	}

	fun participateEvent(caller: User, eventId: Int): Result<EventParticipation> = transaction(db) {
		val event = Event.find {
			Events.id eq eventId and eventService.eventUserCondition(caller)
		}.firstOrNull() ?: return@transaction Result.failure(EventNotFoundException("Event $eventId introuvable"))

		val eventParticipation = EventParticipation.find {
			(EventParticipations.user eq caller.id) and (EventParticipations.event eq event.id)
		}.with(EventParticipation::user).firstOrNull()

		return@transaction if (eventParticipation != null && eventParticipation.isJoined) {
			Result.failure(AlreadyParticipatingToEventException("Vous participez déjà à cet événement"))
		} else if (eventParticipation != null) {
			eventParticipation.isJoined = true
			eventParticipation.joinedDateTime = Clock.System.now()

			Result.success(eventParticipation)
		} else {
			Result.success(
				EventParticipation.new {
					user = caller
					this.event = event
					role = EEventRole.Member
				}
			)
		}
	}

	fun updateUserImageVisibility(
		caller: User,
		eventId: Int,
		isImagesPublic: Boolean
	): Result<EventParticipation> =
		transaction(db) {
			val event = Event.find {
				Events.id eq eventId and eventService.eventUserCondition(caller)
			}.firstOrNull() ?: return@transaction Result.failure(EventNotFoundException("Event $eventId introuvable"))

			val participation = EventParticipation.find {
				eventParticipationUserEventCondition(caller, event)
			}.with(EventParticipation::user).firstOrNull()

			if (participation == null) {
				return@transaction Result.failure(NotParticipatingToEventException("Vous ne participez pas à cet événement"))
			}

			participation.isImagesPublic = isImagesPublic

			Result.success(participation)
		}

	fun leaveEvent(caller: User, eventId: Int): Result<Unit> = transaction(db) {
		val event = Event.find {
			Events.id eq eventId and eventService.eventUserCondition(caller)
		}.firstOrNull() ?: return@transaction Result.failure(EventNotFoundException("Event $eventId introuvable"))

		if (event.owner.id == caller.id) {
			return@transaction Result.failure(EventActionDeniedException("Le propriétaire ne peut pas quitter l'événement"))
		}

		val participation = EventParticipation.find {
			eventParticipationUserEventCondition(caller, event)
		}.firstOrNull()

		if (participation == null) {
			return@transaction Result.failure(NotParticipatingToEventException("Vous ne participez pas à cet événement"))
		}

		participation.isJoined = false
		participation.leftDateTime = Clock.System.now()

		Result.success(Unit)
	}

	fun promoteParticipant(caller: User, eventId: Int, userId: Int): Result<EventParticipation> {
		if (caller.id.value == userId) {
			return Result.failure(EventActionDeniedException("Vous ne pouvez pas vous promouvoir"))
		}

		return transaction(db) {
			val event = Event.find {
				Events.id eq eventId and eventService.eventUserCondition(caller)
			}.firstOrNull() ?: return@transaction Result.failure(EventNotFoundException("Event $eventId introuvable"))

			EventParticipation.find {
				eventParticipationUserEventCondition(caller, event)
			}.firstOrNull()?.apply {
				if (role != EEventRole.Organizer) {
					return@transaction Result.failure(EventActionDeniedException("Seul l'organisateur peut promouvoir un participant"))
				}
			}
				?: return@transaction Result.failure(NotParticipatingToEventException("Vous ne participez pas à cet événement"))


			val user = User.findById(userId)
				?: return@transaction Result.failure(EventNotFoundException("User $userId introuvable"))


			Result.success(
				EventParticipation.find {
					eventParticipationUserEventCondition(user, event)
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
			val event = Event.find {
				Events.id eq eventId and eventService.eventUserCondition(caller)
			}.firstOrNull() ?: return@transaction Result.failure(EventNotFoundException("Event $eventId introuvable"))

			EventParticipation.find {
				eventParticipationUserEventCondition(caller, event)
			}.firstOrNull()?.apply {
				if (role != EEventRole.Organizer) {
					return@transaction Result.failure(EventActionDeniedException("Seul l'organisateur peut rétrograder un participant"))
				}
			}
				?: return@transaction Result.failure(NotParticipatingToEventException("Vous ne participez pas à cet événement"))

			val user = User.findById(userId)
				?: return@transaction Result.failure(EventNotFoundException("User $userId introuvable"))

			Result.success(
				EventParticipation.find {
					eventParticipationUserEventCondition(user, event)
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