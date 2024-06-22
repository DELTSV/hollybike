package hollybike.api.services

import hollybike.api.database.addtime
import hollybike.api.database.now
import hollybike.api.exceptions.*
import hollybike.api.repository.*
import hollybike.api.repository.Event
import hollybike.api.repository.EventParticipation
import hollybike.api.services.storage.StorageService
import hollybike.api.types.event.participation.EEventRole
import hollybike.api.types.event.EEventStatus
import hollybike.api.types.user.EUserScope
import hollybike.api.types.websocket.NewEventNotification
import hollybike.api.utils.search.SearchParam
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
	private val notificationService: NotificationService
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

	private fun checkEventInputDates(
		startDate: Instant,
		endDate: Instant? = null,
		create: Boolean = true
	): Result<Unit> {
		if (startDate < Clock.System.now() && create) {
			return Result.failure(InvalidDateException("La date de début doit être dans le futur"))
		}

		if (endDate == null) {
			return Result.success(Unit)
		}

		if (startDate >= endDate) {
			return Result.failure(InvalidDateException("La date de fin doit être après la date de début"))
		}

		return Result.success(Unit)
	}

	private fun findEventIfOrganizer(eventId: Int, user: User): Result<Event> {
		val event = Event.find {
			Events.id eq eventId and eventUserCondition(user)
		}.with(Event::owner, Event::participants, EventParticipation::user, Event::association).firstOrNull()
			?: return Result.failure(
				EventNotFoundException("Event $eventId introuvable")
			)

		if (user.scope === EUserScope.Root) {
			return Result.success(event)
		}

		val participation = event.participants.find { it.user.id == user.id }
			?: return Result.failure(EventActionDeniedException("Vous ne participez pas à cet événement"))

		if (participation.role != EEventRole.Organizer) {
			return Result.failure(EventActionDeniedException("Seul l'organisateur peut modifier l'événement"))
		}

		return Result.success(event)
	}

	fun eventUserCondition(caller: User): Op<Boolean> {
		return if (caller.scope !== EUserScope.Root) {
			(
				(((Events.owner eq caller.id) and (Events.status eq EEventStatus.Pending.value)) or
					(Events.status neq EEventStatus.Pending.value)) and
					(Events.association eq caller.association.id))
		} else {
			object : Op<Boolean>() {
				override fun toQueryBuilder(queryBuilder: QueryBuilder) {
					queryBuilder.append("true")
				}
			}
		}
	}

	private fun eventsQuery(caller: User, searchParam: SearchParam, pagination: Boolean = true): Query {
		val participation = EventParticipations.alias("participation")
		val participant = Users.alias("participant")

		val eventsQuery = Events.innerJoin(
			Associations,
			{ association },
			{ Associations.id }
		).innerJoin(
			Users,
			{ Events.owner },
			{ Users.id }
		).leftJoin(
			participation,
			{ participation[EventParticipations.event] },
			{ Events.id },
		).leftJoin(
			participant,
			{ participant[Users.id] },
			{ participation[EventParticipations.user] },
			{ participation[EventParticipations.isJoined] eq true }
		).select(Events.columns + Users.columns + Associations.columns)
			.applyParam(searchParam, pagination).withDistinct()

		if (caller.scope != EUserScope.Root) {
			eventsQuery.andWhere {
				eventUserCondition(caller)
			}
		}

		return eventsQuery
	}

	suspend fun handleEventExceptions(exception: Throwable, call: ApplicationCall) {
		when (exception) {
			is EventNotFoundException -> call.respond(
				HttpStatusCode.NotFound,
				exception.message ?: "Évènement inconnu"
			)

			is EventActionDeniedException -> call.respond(
				HttpStatusCode.Forbidden,
				exception.message ?: "Action denied"
			)

			is InvalidDateException -> call.respond(
				HttpStatusCode.BadRequest,
				exception.message ?: "Date invalide"
			)

			is InvalidEventNameException -> call.respond(
				HttpStatusCode.BadRequest,
				exception.message ?: "Nom de l'évènement vide ou invalide"
			)

			is InvalidEventDescriptionException -> call.respond(
				HttpStatusCode.BadRequest,
				exception.message ?: "Description de l'événement invalide"
			)

			is AlreadyParticipatingToEventException -> call.respond(
				HttpStatusCode.Conflict,
				exception.message ?: "Vous participer déjà à l'événement"
			)

			is NotParticipatingToEventException -> call.respond(
				HttpStatusCode.NotFound,
				exception.message ?: "Vous ne participez pas à l'évènements"
			)

			is JourneyNotFoundException -> call.respond(
				HttpStatusCode.NotFound,
				exception.message ?: "Trajet introuvable"
			)

			else -> {
				exception.printStackTrace()
				call.respond(HttpStatusCode.InternalServerError, "Internal server error")
			}
		}
	}

	fun getAllEvents(caller: User, searchParam: SearchParam): List<Event> = transaction(db) {
		Event.wrapRows(
			eventsQuery(caller, searchParam)
		).with(Event::owner, Event::association).toList()
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
		Event.wrapRows(
			eventsQuery(caller, searchParam).andWhere { futureEventsCondition() }
		).with(Event::owner, Event::association).toList()
	}

	fun countFutureEvents(caller: User, searchParam: SearchParam): Int = transaction(db) {
		eventsQuery(caller, searchParam, pagination = false).andWhere { futureEventsCondition() }.count().toInt()
	}

	private fun archivedEventsCondition(): Op<Boolean> {
		return (Events.startDateTime less now()) and
			(((Events.endDateTime neq null) and (Events.endDateTime less now())) or
				((Events.endDateTime eq null) and (addtime(Events.startDateTime, 4.hours) less now())))
	}

	fun getArchivedEvents(caller: User, searchParam: SearchParam): List<Event> = transaction(db) {
		Event.wrapRows(
			eventsQuery(caller, searchParam).andWhere { archivedEventsCondition() }
		).with(Event::owner, Event::association).toList()
	}

	fun countArchivedEvents(caller: User, searchParam: SearchParam): Int = transaction(db) {
		eventsQuery(caller, searchParam, pagination = false).andWhere { archivedEventsCondition() }.count().toInt()
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

		Event.wrapRow(eventRow).load(
			Event::owner,
			Event::association,
			Event::journey,
			Journey::start,
			Journey::end,
			Journey::destination
		) to try {
			EventParticipation.wrapRow(eventRow).load(EventParticipation::user)
		} catch (e: Throwable) {
			null
		}
	}

	fun getEvent(caller: User, id: Int): Event? = transaction(db) {
		Event.find {
			Events.id eq id and eventUserCondition(caller)
		}.with(Event::owner, Event::participants, EventParticipation::user, Event::association).firstOrNull()
			?: return@transaction null
	}

	suspend fun createEvent(
		caller: User,
		name: String,
		description: String?,
		startDate: Instant,
		endDate: Instant?,
		association: Association
	): Result<Event> {
		checkEventInputDates(startDate, endDate).onFailure { return Result.failure(it) }
		checkEventTextFields(name, description).onFailure { return Result.failure(it) }

		return transaction(db) {
			val createdEvent = Event.new {
				owner = caller
				this.association = association
				this.name = name
				this.description = description
				this.startDateTime = startDate
				this.endDateTime = endDate
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
		}.apply {
			onSuccess { e ->
				notificationService.sendToAssociation(
					association.id.value,
					NewEventNotification(
						e.id.value,
						e.name,
						e.description,
						e.startDateTime,
						e.signedImage,
						e.owner.id.value,
						e.owner.username
					)
				)
			}
		}
	}

	fun addJourneyToEvent(caller: User, eventId: Int, journeyId: Int): Result<Unit> = transaction(db) {
		findEventIfOrganizer(eventId, caller).onFailure { return@transaction Result.failure(it) }.onSuccess {
			val journey = Journey.find { Journeys.id eq journeyId }.firstOrNull() ?: return@transaction Result.failure(
				JourneyNotFoundException("Trajet $journeyId introuvable")
			)

			it.journey = journey

			return@transaction Result.success(Unit)
		}

		Result.success(Unit)
	}

	fun removeJourneyFromEvent(caller: User, eventId: Int): Result<Unit> = transaction(db) {
		findEventIfOrganizer(eventId, caller).onFailure { return@transaction Result.failure(it) }.onSuccess {
			it.journey = null

			return@transaction Result.success(Unit)
		}

		Result.success(Unit)
	}

	fun updateEvent(
		caller: User,
		eventId: Int,
		name: String,
		description: String?,
		startDate: Instant,
		endDate: Instant?,
	): Result<Event> {
		checkEventInputDates(startDate, endDate, false).onFailure { return Result.failure(it) }
		checkEventTextFields(name, description).onFailure { return Result.failure(it) }

		return transaction(db) {
			findEventIfOrganizer(eventId, caller).onFailure { return@transaction Result.failure(it) }
				.onSuccess { event ->
					event.apply {
						this.name = name
						this.description = description
						this.startDateTime = startDate
						this.endDateTime = endDate
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
			findEventIfOrganizer(eventId, caller).onFailure { return@transaction Result.failure(it) }.onSuccess {
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