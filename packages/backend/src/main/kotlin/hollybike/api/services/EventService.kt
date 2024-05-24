package hollybike.api.services

import hollybike.api.exceptions.*
import hollybike.api.repository.User
import hollybike.api.repository.events.Event
import hollybike.api.repository.events.Events
import hollybike.api.repository.events.participations.EventParticipation
import hollybike.api.repository.events.participations.EventParticipations
import hollybike.api.services.storage.StorageService
import hollybike.api.types.event.EEventRole
import hollybike.api.types.event.EEventStatus
import kotlinx.coroutines.runBlocking
import kotlinx.datetime.Clock
import kotlinx.datetime.Instant
import org.jetbrains.exposed.dao.with
import org.jetbrains.exposed.sql.*
import org.jetbrains.exposed.sql.SqlExpressionBuilder.eq
import org.jetbrains.exposed.sql.SqlExpressionBuilder.neq
import org.jetbrains.exposed.sql.transactions.transaction

class EventService(
	private val db: Database,
	private val storageService: StorageService,
) {
	private fun checkEventTextFields(name: String, description: String?): Result<Unit> {
		if (name.isBlank()) {
			return Result.failure(InvalidEventNameException("Le nom de l'événement ne peut pas être vide"))
		}

		if (name.length > 100) {
			return Result.failure(InvalidEventNameException("Le nom de l'événement ne peut pas dépasser 100 caractères"))
		}

		if (description != null && description.isBlank()) {
			return Result.failure(InvalidEventDescriptionException("La description de l'événement ne peut pas être vide"))
		}

		if (description != null && description.length > 1000) {
			return Result.failure(InvalidEventDescriptionException("La description de l'événement ne peut pas dépasser 1000 caractères"))
		}

		return Result.success(Unit)
	}

	private fun checkEventInputDates(startDate: String, endDate: String? = null): Result<Unit> {
		val parsedStartDate = try {
			Instant.parse(startDate)
		} catch (e: IllegalArgumentException) {
			return Result.failure(InvalidDateException("Format de la date de début invalide"))
		}

		if (parsedStartDate < Clock.System.now()) {
			return Result.failure(InvalidDateException("La date de début doit être dans le futur"))
		}

		if (endDate == null) {
			return Result.success(Unit)
		}

		val parsedEndDate = try {
			Instant.parse(endDate)
		} catch (e: IllegalArgumentException) {
			return Result.failure(InvalidDateException("Format de la date de fin invalide"))
		}

		if (parsedStartDate >= parsedEndDate) {
			return Result.failure(InvalidDateException("La date de fin doit être après la date de début"))
		}

		return Result.success(Unit)
	}

	private fun foundEventIfOrganizer(eventId: Int, user: User): Result<Event> {
		val event = Event.find {
			Events.id eq eventId and eventUserCondition(user)
		}.with(Event::owner, Event::participants, EventParticipation::user).firstOrNull() ?: return Result.failure(
			EventNotFoundException("Event $eventId introuvable")
		)

		val participation = event.participants.find { it.user.id == user.id }
			?: return Result.failure(EventActionDeniedException("Vous ne participez pas à cet événement"))

		if (participation.role != EEventRole.ORGANIZER) {
			return Result.failure(EventActionDeniedException("Seul l'organisateur peut modifier l'événement"))
		}

		return Result.success(event)
	}

	private fun eventUserCondition(caller: User): Op<Boolean> = (Events.owner eq caller.id)
		.and(Events.status eq EEventStatus.PENDING.value)
		.or(Events.status neq EEventStatus.PENDING.value)
		.and(Events.association eq caller.association.id)

	fun getEvents(caller: User, perPage: Int, page: Int): List<Event> = transaction(db) {
		Event.find {
			eventUserCondition(caller)
		}.orderBy(
			Events.startDateTime to SortOrder.ASC,
		).limit(perPage, offset = (page * perPage).toLong()).with(Event::owner).toList()
	}

	fun countEvents(caller: User): Int = transaction(db) {
		Event.find {
			eventUserCondition(caller)
		}.count().toInt()
	}

	fun getEvent(caller: User, id: Int): Event? = transaction(db) {
		Event.find {
			Events.id eq id and eventUserCondition(caller)
		}.with(Event::owner, Event::participants, EventParticipation::user).firstOrNull()
	}

	fun createEvent(
		caller: User,
		name: String,
		description: String?,
		startDate: String,
		endDate: String?,
	): Result<Pair<Event, EventParticipation>> {
		checkEventInputDates(startDate, endDate).onFailure { return Result.failure(it) }
		checkEventTextFields(name, description).onFailure { return Result.failure(it) }

		return transaction(db) {
			val createdEvent = Event.new {
				owner = caller
				association = caller.association
				this.name = name
				this.description = description
				this.startDateTime = Instant.parse(startDate)
				this.endDateTime = endDate?.let { Instant.parse(it) }
				status = EEventStatus.PENDING
			}

			val participation = EventParticipation.new {
				user = caller
				event = createdEvent
				role = EEventRole.ORGANIZER
			}

			Result.success(
				createdEvent to participation
			)
		}
	}

	fun updateEvent(
		caller: User,
		eventId: Int,
		name: String,
		description: String?,
		startDate: String,
		endDate: String?,
	): Result<Event> {
		checkEventInputDates(startDate, endDate).onFailure { return Result.failure(it) }
		checkEventTextFields(name, description).onFailure { return Result.failure(it) }

		return transaction(db) {
			foundEventIfOrganizer(eventId, caller).onFailure { return@transaction Result.failure(it) }
				.onSuccess { event ->
					event.apply {
						this.name = name
						this.description = description
						this.startDateTime = Instant.parse(startDate)
						this.endDateTime = endDate?.let { Instant.parse(it) }
					}

					Result.success(event)
				}
		}
	}

	fun updateEventStatus(caller: User, eventId: Int, status: EEventStatus): Result<Unit> = transaction(db) {
		val event = Event.find {
			Events.id eq eventId and eventUserCondition(caller)
		}.firstOrNull() ?: return@transaction Result.failure(EventNotFoundException("Event $eventId introuvable"))

		val participation = EventParticipation.find {
			(EventParticipations.user eq caller.id) and (EventParticipations.event eq eventId)
		}.firstOrNull()
			?: return@transaction Result.failure(EventActionDeniedException("Vous ne participez pas à cet événement"))

		if (participation.role != EEventRole.ORGANIZER) {
			return@transaction Result.failure(EventActionDeniedException("Seul l'organisateur peut modifier le statut de l'événement"))
		}

		if (status == event.status) {
			return@transaction Result.failure(EventActionDeniedException("Event déjà ${status.name.lowercase()}"))
		}

		when (status) {
			EEventStatus.PENDING -> {
				if (event.owner.id != caller.id) {
					return@transaction Result.failure(EventActionDeniedException("Seul le propriétaire peut mettre l'événement en attente"))
				}
			}

			EEventStatus.CANCELLED -> {
				if (event.status != EEventStatus.SCHEDULED) {
					return@transaction Result.failure(EventActionDeniedException("Seul un événement planifié peut être annulé"))
				}
			}

			EEventStatus.FINISHED -> {
				if (event.status != EEventStatus.SCHEDULED) {
					return@transaction Result.failure(EventActionDeniedException("Seul un événement planifié peut être terminé"))
				}
			}

			EEventStatus.SCHEDULED -> Unit
		}

		event.status = status

		Result.success(Unit)
	}

	fun uploadEventImage(caller: User, eventId: Int, image: ByteArray, imageContentType: String): Result<Event> =
		transaction(db) {
			foundEventIfOrganizer(eventId, caller).onFailure { return@transaction Result.failure(it) }.onSuccess {
				val path = "e/$eventId/i"

				runBlocking {
					storageService.store(image, path, imageContentType)
				}

				it.image = path

				Result.success(it)
			}
		}

	fun deleteEvent(caller: User, eventId: Int): Result<Unit> = transaction(db) {
		val event = Event.find {
			Events.id eq eventId and eventUserCondition(caller)
		}.firstOrNull() ?: return@transaction Result.failure(EventNotFoundException("Event $eventId introuvable"))

		if (event.owner.id != caller.id) {
			return@transaction Result.failure(EventActionDeniedException("Seul le propriétaire peut supprimer l'événement"))
		}

		Result.success(event.delete())
	}

	fun participateEvent(caller: User, eventId: Int): Result<EventParticipation> = transaction(db) {
		Event.find {
			Events.id eq eventId and eventUserCondition(caller)
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
				role = EEventRole.MEMBER
			}
		)
	}

	fun leaveEvent(caller: User, eventId: Int): Result<Unit> = transaction(db) {
		val event = Event.find {
			Events.id eq eventId and eventUserCondition(caller)
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
				Events.id eq eventId and eventUserCondition(caller)
			}.firstOrNull() ?: return@transaction Result.failure(EventNotFoundException("Event $eventId introuvable"))

			EventParticipation.find {
				(EventParticipations.user eq caller.id) and (EventParticipations.event eq eventId)
			}.firstOrNull()?.apply {
				if (role != EEventRole.ORGANIZER) {
					return@transaction Result.failure(EventActionDeniedException("Seul l'organisateur peut promouvoir un participant"))
				}
			} ?: return@transaction Result.failure(NotParticipatingToEventException("Vous ne participez pas à cet événement"))

			Result.success(
				EventParticipation.find {
					(EventParticipations.user eq userId) and (EventParticipations.event eq eventId)
				}.with(EventParticipation::user).firstOrNull()?.apply {
					if (role == EEventRole.MEMBER) {
						role = EEventRole.ORGANIZER
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
				Events.id eq eventId and eventUserCondition(caller)
			}.firstOrNull() ?: return@transaction Result.failure(EventNotFoundException("Event $eventId introuvable"))

			EventParticipation.find {
				(EventParticipations.user eq caller.id) and (EventParticipations.event eq eventId)
			}.firstOrNull()?.apply {
				if (role != EEventRole.ORGANIZER) {
					return@transaction Result.failure(EventActionDeniedException("Seul l'organisateur peut rétrograder un participant"))
				}
			} ?: return@transaction Result.failure(NotParticipatingToEventException("Vous ne participez pas à cet événement"))

			Result.success(
				EventParticipation.find {
					(EventParticipations.user eq userId) and (EventParticipations.event eq eventId)
				}.with(EventParticipation::user).firstOrNull()?.apply {
					if (role == EEventRole.ORGANIZER) {
						role = EEventRole.MEMBER
					} else {
						return@transaction Result.failure(EventActionDeniedException("Seul un organisateur peut être rétrogradé"))
					}
				}
					?: return@transaction Result.failure(NotParticipatingToEventException("L'utilisateur ne participe pas à cet événement"))
			)
		}
	}
}