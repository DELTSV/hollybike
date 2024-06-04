package hollybike.api.services

import hollybike.api.database.addtime
import hollybike.api.database.now
import hollybike.api.exceptions.*
import hollybike.api.repository.*
import hollybike.api.repository.Event
import hollybike.api.repository.EventParticipation
import hollybike.api.services.storage.StorageService
import hollybike.api.types.event.EEventRole
import hollybike.api.types.event.EEventStatus
import hollybike.api.types.user.EUserScope
import hollybike.api.utils.search.SearchParam
import hollybike.api.utils.search.Sort
import hollybike.api.utils.search.applyParam
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.response.*
import kotlinx.coroutines.runBlocking
import kotlinx.datetime.Clock
import kotlinx.datetime.Instant
import org.jetbrains.exposed.dao.load
import org.jetbrains.exposed.dao.with
import org.jetbrains.exposed.sql.*
import org.jetbrains.exposed.sql.SqlExpressionBuilder.eq
import org.jetbrains.exposed.sql.SqlExpressionBuilder.greaterEq
import org.jetbrains.exposed.sql.SqlExpressionBuilder.less
import org.jetbrains.exposed.sql.SqlExpressionBuilder.neq
import org.jetbrains.exposed.sql.transactions.transaction
import kotlin.time.Duration.Companion.hours

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

		if (participation.role != EEventRole.Organizer) {
			return Result.failure(EventActionDeniedException("Seul l'organisateur peut modifier l'événement"))
		}

		return Result.success(event)
	}

	fun eventUserCondition(caller: User): Op<Boolean> {
		return ((((Events.owner eq caller.id) and (Events.status eq EEventStatus.Pending.value)) or (Events.status neq EEventStatus.Pending.value)) and (Events.association eq caller.association.id))
	}

	private fun eventsQuery(caller: User, searchParam: SearchParam, pagination: Boolean = true): SizedIterable<Event> {
		val eventsQuery = Events.innerJoin(
			Associations,
			{ association },
			{ Associations.id }
		).innerJoin(
			Users,
			{ Events.owner },
			{ Users.id }
		).selectAll().applyParam(searchParam, pagination)

		if (caller.scope != EUserScope.Root) {
			eventsQuery.andWhere {
				eventUserCondition(caller)
			}
		}

		return Event.wrapRows(eventsQuery)
	}

	suspend fun handleEventExceptions(exception: Throwable, call: ApplicationCall) {
		when (exception) {
			is EventNotFoundException -> call.respond(
				HttpStatusCode.NotFound,
				exception.message ?: "Event not found"
			)

			is EventActionDeniedException -> call.respond(
				HttpStatusCode.Forbidden,
				exception.message ?: "Action denied"
			)

			is InvalidDateException -> call.respond(
				HttpStatusCode.BadRequest,
				exception.message ?: "Invalid date"
			)

			is InvalidEventNameException -> call.respond(
				HttpStatusCode.BadRequest,
				exception.message ?: "Invalid event name"
			)

			is InvalidEventDescriptionException -> call.respond(
				HttpStatusCode.BadRequest,
				exception.message ?: "Invalid event description"
			)

			is AlreadyParticipatingToEventException -> call.respond(
				HttpStatusCode.Conflict,
				exception.message ?: "Already participating to event"
			)

			is NotParticipatingToEventException -> call.respond(
				HttpStatusCode.NotFound,
				exception.message ?: "Not participating to event"
			)

			else -> {
				exception.printStackTrace()
				call.respond(HttpStatusCode.InternalServerError, "Internal server error")
			}
		}
	}

	fun getAllEvents(caller: User, searchParam: SearchParam): List<Event> = transaction(db) {
		eventsQuery(caller, searchParam).with(Event::owner).toList()
	}

	fun countAllEvents(caller: User, searchParam: SearchParam): Int = transaction(db) {
		eventsQuery(caller, searchParam, pagination = false).count().toInt()
	}

	private fun futureEventsCondition(): Op<Boolean> {
		return (Events.startDateTime greaterEq now()) or
			((Events.endDateTime neq null) and (Events.endDateTime greaterEq now())) or
			((Events.endDateTime eq null) and (addtime(Events.startDateTime, 4.hours) greaterEq now()))
	}

	fun getFutureEvents(caller: User, searchParam: SearchParam): List<Event> = transaction(db) {
		Event.wrapRows(Events.selectAll().applyParam(searchParam).andWhere {
			eventUserCondition(caller) and futureEventsCondition()
		}).with(Event::owner).toList()
	}

	fun countFutureEvents(caller: User, searchParam: SearchParam): Int = transaction(db) {
		Events.selectAll().applyParam(searchParam).andWhere {
			eventUserCondition(caller) and futureEventsCondition()
		}.count().toInt()
	}

	private fun archivedEventsCondition(): Op<Boolean> {
		return (Events.startDateTime less now()) and
			(((Events.endDateTime neq null) and (Events.endDateTime less now())) or
				((Events.endDateTime eq null) and (addtime(Events.startDateTime, 4.hours) less now())))
	}

	fun getArchivedEvents(caller: User, searchParam: SearchParam): List<Event> = transaction(db) {
		Event.wrapRows(Events.selectAll().applyParam(searchParam).andWhere {
			eventUserCondition(caller) and archivedEventsCondition()
		}).with(Event::owner).toList()
	}

	fun countArchivedEvents(caller: User, searchParam: SearchParam): Int = transaction(db) {
		Events.selectAll().applyParam(searchParam).andWhere {
			eventUserCondition(caller) and archivedEventsCondition()
		}.count().toInt()
	}

	fun getEventWithParticipation(caller: User, id: Int): Pair<Event, EventParticipation?>? = transaction(db) {
		val eventRow = Events.innerJoin(
			Users,
			{ owner },
			{ Users.id }
		).leftJoin(
			EventParticipations,
			{ Events.id },
			{ event },
			{ (EventParticipations.user eq caller.id) and (EventParticipations.isJoined eq true) }
		).selectAll().where {
			Events.id eq id and eventUserCondition(caller)
		}.firstOrNull() ?: return@transaction null

		Event.wrapRow(eventRow).load(Event::owner) to try {
			EventParticipation.wrapRow(eventRow).load(EventParticipation::user)
		} catch (e: Throwable) {
			null
		}
	}

	fun getEvent(caller: User, id: Int): Event? = transaction(db) {
		Event.find {
			Events.id eq id and eventUserCondition(caller)
		}.with(Event::owner, Event::participants, EventParticipation::user).firstOrNull() ?: return@transaction null
	}

	fun createEvent(
		caller: User,
		name: String,
		description: String?,
		startDate: String,
		endDate: String?,
	): Result<Event> {
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
				status = EEventStatus.Pending
			}

			EventParticipation.new {
				user = caller
				event = createdEvent
				role = EEventRole.Organizer
			}

			Result.success(
				createdEvent
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

		if (participation.role != EEventRole.Organizer) {
			return@transaction Result.failure(EventActionDeniedException("Seul l'organisateur peut modifier le statut de l'événement"))
		}

		if (status == event.status) {
			return@transaction Result.failure(EventActionDeniedException("Event déjà ${status.name.lowercase()}"))
		}

		when (status) {
			EEventStatus.Pending -> {
				if (event.owner.id != caller.id) {
					return@transaction Result.failure(EventActionDeniedException("Seul le propriétaire peut mettre l'événement en attente"))
				}
			}

			EEventStatus.Cancelled -> {
				if (event.status != EEventStatus.Scheduled) {
					return@transaction Result.failure(EventActionDeniedException("Seul un événement planifié peut être annulé"))
				}
			}

			EEventStatus.Finished -> {
				if (event.status != EEventStatus.Scheduled) {
					return@transaction Result.failure(EventActionDeniedException("Seul un événement planifié peut être terminé"))
				}
			}

			EEventStatus.Scheduled -> Unit
			EEventStatus.Now -> Unit
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
}