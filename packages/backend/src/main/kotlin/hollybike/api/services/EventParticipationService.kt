package hollybike.api.services

import hollybike.api.exceptions.AlreadyParticipatingToEventException
import hollybike.api.exceptions.EventActionDeniedException
import hollybike.api.exceptions.EventNotFoundException
import hollybike.api.exceptions.NotParticipatingToEventException
import hollybike.api.repository.*
import hollybike.api.types.event.EEventRole
import hollybike.api.utils.search.SearchParam
import hollybike.api.utils.search.Sort
import hollybike.api.utils.search.applyParam
import io.ktor.server.application.*
import kotlinx.datetime.Clock
import org.jetbrains.exposed.dao.load
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

	private fun eventParticipationUserEventCondition(caller: User, eventId: Int): Op<Boolean> =
		EventParticipations.run {
			(user eq caller.id) and eventParticipationCondition(eventId)
		}

	private fun eventParticipationCondition(eventId: Int): Op<Boolean> = EventParticipations.run {
		(this.event eq eventId) and (isJoined eq true)
	}

	private fun eventCandidatesQuery(
		caller: User,
		eventId: Int,
		searchParam: SearchParam,
		withPagination: Boolean = true
	): Query {
		return Users
			.leftJoin(
				EventParticipations,
				{ Users.id },
				{ user },
				{ (EventParticipations.event eq eventId) and (EventParticipations.isJoined eq true) })
			.leftJoin(
				Events,
				{ EventParticipations.event },
				{ Events.id },
			)
			.selectAll()
			.applyParam(searchParam, withPagination)
			.andWhere { (Users.association eq caller.association.id) and (Users.id neq caller.id) }
	}

	private fun findEvent(caller: User, eventId: Int): Event? {
		return Event.find {
			Events.id eq eventId and eventService.eventUserCondition(caller)
		}.firstOrNull()
	}

	fun getParticipationCandidates(
		caller: User,
		eventId: Int,
		searchParam: SearchParam
	): Result<List<Pair<User, EventParticipation?>>> = transaction(db) {
		findEvent(caller, eventId)
			?: return@transaction Result.failure(EventNotFoundException("Event $eventId introuvable"))

		val query = eventCandidatesQuery(caller, eventId, searchParam)

		Result.success(
			query.map { row ->
				User.wrapRow(row) to try {
					EventParticipation.wrapRow(row).load(EventParticipation::event, Event::owner)
				} catch (e: Throwable) {
					null
				}
			}.toList()
		)
	}

	fun countParticipationCandidates(
		caller: User,
		eventId: Int,
		searchParam: SearchParam
	): Result<Int> = transaction(db) {
		findEvent(caller, eventId)
			?: return@transaction Result.failure(EventNotFoundException("Event $eventId introuvable"))

		val query = eventCandidatesQuery(caller, eventId, searchParam, false)

		Result.success(query.count().toInt())
	}

	fun getEventParticipations(caller: User, eventId: Int, searchParam: SearchParam): Result<List<EventParticipation>> =
		transaction(db) {
			findEvent(caller, eventId)
				?: return@transaction Result.failure(EventNotFoundException("Event $eventId introuvable"))

			Result.success(
				EventParticipation.wrapRows(
					EventParticipations.innerJoin(Events, { this.event }, { Events.id })
						.selectAll()
						.applyParam(searchParam)
						.andWhere { eventService.eventUserCondition(caller) and eventParticipationCondition(eventId) }
				).with(EventParticipation::user).toList()
			)
		}

	fun getEventParticipationsCount(caller: User, eventId: Int, searchParam: SearchParam): Result<Int> =
		transaction(db) {
			findEvent(caller, eventId)
				?: return@transaction Result.failure(EventNotFoundException("Event $eventId introuvable"))

			Result.success(
				EventParticipations.innerJoin(Events, { this.event }, { Events.id })
					.selectAll()
					.applyParam(searchParam, false)
					.andWhere { eventService.eventUserCondition(caller) and eventParticipationCondition(eventId) }
					.count()
					.toInt()
			)
		}

	fun participateEvent(caller: User, eventId: Int): Result<EventParticipation> = transaction(db) {
		findEvent(caller, eventId)
			?: return@transaction Result.failure(EventNotFoundException("Event $eventId introuvable"))

		val eventParticipation = EventParticipation.find {
			(EventParticipations.user eq caller.id) and (EventParticipations.event eq eventId)
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
					this.event = Event[eventId]
					role = EEventRole.Member
				}
			)
		}
	}

	fun removeUserFromEvent(caller: User, eventId: Int, userId: Int): Result<Unit> = transaction(db) {
		val event = findEvent(caller, eventId)
			?: return@transaction Result.failure(EventNotFoundException("Event $eventId introuvable"))

		if (caller.id.value == userId) {
			return@transaction Result.failure(EventActionDeniedException("Vous ne pouvez pas vous retirer de l'événement"))
		}

		if (event.owner.id.value == userId) {
			return@transaction Result.failure(EventActionDeniedException("Vous ne pouvez pas retirer le propriétaire de l'événement"))
		}

		val participation = EventParticipation.find {
			eventParticipationUserEventCondition(caller, eventId)
		}.firstOrNull()

		if (participation == null) {
			return@transaction Result.failure(NotParticipatingToEventException("Vous ne participez pas à cet événement"))
		}

		if (participation.role != EEventRole.Organizer) {
			return@transaction Result.failure(EventActionDeniedException("Seul un organisateur peut retirer un participant"))
		}

		val user = User.findById(userId)
			?: return@transaction Result.failure(EventNotFoundException("User $userId introuvable"))

		val userParticipation = EventParticipation.find {
			eventParticipationUserEventCondition(user, eventId)
		}.firstOrNull()

		if (userParticipation == null) {
			return@transaction Result.failure(NotParticipatingToEventException("L'utilisateur ne participe pas à cet événement"))
		}

		userParticipation.isJoined = false
		userParticipation.leftDateTime = Clock.System.now()

		Result.success(Unit)
	}

	fun addParticipantsToEvent(
		caller: User,
		eventId: Int,
		userIds: List<Int>
	): Result<List<EventParticipation>> = transaction(db) {
		val event = findEvent(caller, eventId)
			?: return@transaction Result.failure(EventNotFoundException("Event $eventId introuvable"))

		val participation = EventParticipation.find {
			eventParticipationUserEventCondition(caller, eventId)
		}.firstOrNull()

		if (participation == null) {
			return@transaction Result.failure(NotParticipatingToEventException("Vous ne participez pas à cet événement"))
		}

		if (participation.role != EEventRole.Organizer) {
			return@transaction Result.failure(EventActionDeniedException("Seul l'organisateur peut ajouter des participants"))
		}

		val users = User.find { Users.id inList userIds }

		Result.success(
			users.map { user ->
				val userParticipation = EventParticipation.find {
					(EventParticipations.user eq user.id) and (EventParticipations.event eq eventId)
				}.with(EventParticipation::user).firstOrNull()

				if (userParticipation == null) {
					EventParticipation.new {
						this.user = user
						this.event = event
						role = EEventRole.Member
					}
				} else if (userParticipation.isJoined.not()) {
					userParticipation.isJoined = true
					userParticipation.joinedDateTime = Clock.System.now()

					userParticipation
				} else {
					return@transaction Result.failure(AlreadyParticipatingToEventException("L'utilisateur ${user.id} participe déjà à cet événement"))
				}
			}
		)
	}

	fun updateUserImageVisibility(
		caller: User,
		eventId: Int,
		isImagesPublic: Boolean
	): Result<EventParticipation> = transaction(db) {
		findEvent(caller, eventId)
			?: return@transaction Result.failure(EventNotFoundException("Event $eventId introuvable"))

		val participation = EventParticipation.find {
			eventParticipationUserEventCondition(caller, eventId)
		}.with(EventParticipation::user).firstOrNull()

		if (participation == null) {
			return@transaction Result.failure(NotParticipatingToEventException("Vous ne participez pas à cet événement"))
		}

		participation.isImagesPublic = isImagesPublic

		Result.success(participation)
	}

	fun leaveEvent(caller: User, eventId: Int): Result<Unit> = transaction(db) {
		val event = findEvent(caller, eventId)
			?: return@transaction Result.failure(EventNotFoundException("Event $eventId introuvable"))

		if (event.owner.id == caller.id) {
			return@transaction Result.failure(EventActionDeniedException("Le propriétaire ne peut pas quitter l'événement"))
		}

		val participation = EventParticipation.find {
			eventParticipationUserEventCondition(caller, eventId)
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
			findEvent(caller, eventId)
				?: return@transaction Result.failure(EventNotFoundException("Event $eventId introuvable"))

			EventParticipation.find {
				eventParticipationUserEventCondition(caller, eventId)
			}.firstOrNull()?.apply {
				if (role != EEventRole.Organizer) {
					return@transaction Result.failure(EventActionDeniedException("Seul l'organisateur peut promouvoir un participant"))
				}
			}
				?: return@transaction Result.failure(NotParticipatingToEventException("Vous ne participez pas à cet événement"))

			val user = User.find { (Users.id eq userId) and (Users.association eq caller.association.id) }.firstOrNull()
				?: return@transaction Result.failure(EventNotFoundException("User $userId introuvable"))

			Result.success(
				EventParticipation.find {
					eventParticipationUserEventCondition(user, eventId)
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
			findEvent(caller, eventId)
				?: return@transaction Result.failure(EventNotFoundException("Event $eventId introuvable"))

			EventParticipation.find {
				eventParticipationUserEventCondition(caller, eventId)
			}.firstOrNull()?.apply {
				if (role != EEventRole.Organizer) {
					return@transaction Result.failure(EventActionDeniedException("Seul l'organisateur peut rétrograder un participant"))
				}
			}
				?: return@transaction Result.failure(NotParticipatingToEventException("Vous ne participez pas à cet événement"))

			val user = User.find { (Users.id eq userId) and (Users.association eq caller.association.id) }.firstOrNull()
				?: return@transaction Result.failure(EventNotFoundException("User $userId introuvable"))

			Result.success(
				EventParticipation.find {
					eventParticipationUserEventCondition(user, eventId)
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

	fun getParticipationsPreview(caller: User, eventId: Int): Result<Pair<List<EventParticipation>, Int>> {
		val searchParam = SearchParam(
			sort = listOf(Sort(EventParticipations.joinedDateTime, SortOrder.ASC)),
			query = null,
			filter = mutableListOf(),
			page = 0,
			perPage = 5
		)

		val participations = getEventParticipations(caller, eventId, searchParam)
			.getOrElse { return Result.failure(it) }

		val participationCount = getEventParticipationsCount(caller, eventId, searchParam)
			.getOrElse { return Result.failure(it) }

		return Result.success(participations to participationCount)
	}
}