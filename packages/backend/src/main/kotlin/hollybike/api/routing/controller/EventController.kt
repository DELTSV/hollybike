package hollybike.api.routing.controller

import hollybike.api.json
import hollybike.api.plugins.user
import hollybike.api.repository.associationMapper
import hollybike.api.repository.eventMapper
import hollybike.api.repository.userMapper
import hollybike.api.routing.resources.Events
import hollybike.api.services.*
import hollybike.api.services.storage.StorageService
import hollybike.api.types.event.*
import hollybike.api.types.event.participation.TUserJourney
import hollybike.api.types.journey.GeoJson
import hollybike.api.types.journey.toGpx
import hollybike.api.types.lists.TLists
import hollybike.api.types.user.EUserScope
import hollybike.api.utils.checkContentType
import hollybike.api.utils.get
import hollybike.api.utils.search.getMapperData
import hollybike.api.utils.search.getSearchParam
import io.ktor.http.*
import io.ktor.http.content.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.request.*
import io.ktor.server.resources.*
import io.ktor.server.resources.patch
import io.ktor.server.resources.post
import io.ktor.server.resources.put
import io.ktor.server.response.*
import io.ktor.server.routing.*
import kotlinx.serialization.decodeFromString
import kotlinx.serialization.encodeToString
import nl.adaptivity.xmlutil.ExperimentalXmlUtilApi
import nl.adaptivity.xmlutil.serialization.UnknownChildHandler
import nl.adaptivity.xmlutil.serialization.XML

class EventController(
	application: Application,
	private val eventService: EventService,
	private val eventParticipationService: EventParticipationService,
	private val associationService: AssociationService,
	private val userService: UserService,
	private val userEventPositionService: UserEventPositionService,
	private val expenseService: ExpenseService,
	private val storageService: StorageService
) {
	private val mapper = eventMapper + associationMapper + userMapper

	init {
		application.routing {
			authenticate {
				getAllEvents()
				getFutureEvents()
				getArchivedEvents()
				getEventDetails()
				getEventExpenseReport()
				getEvent()
				createEvent()
				addJourneyToEvent()
				removeJourneyFromEvent()
				updateEvent()
				uploadEventImage()
				deleteEvent()
				cancelEvent()
				scheduleEvent()
				finishEvent()
				pendEvent()
				getMetaData()
				getParticipantJourney()
				getMyJourneyFile()
				getParticipantJourneyFile()
				terminateEventJourney()
				removeEventJourney()
			}
		}
	}

	@OptIn(ExperimentalXmlUtilApi::class)
	private val xml = XML {
		defaultPolicy {
			unknownChildHandler =
				UnknownChildHandler { _, _, _, name, _ ->
					emptyList()
				}
		}
	}

	private fun Route.getAllEvents() {
		get<Events> {
			val params = call.request.queryParameters.getSearchParam(mapper)

			val events = eventService.getAllEvents(call.user, params)
			val totalEvents = eventService.countAllEvents(call.user, params)

			call.respond(TLists(events.map { TEventPartial(it) }, params, totalEvents))
		}
	}

	private fun Route.getFutureEvents() {
		get<Events.Future> {
			val searchParam = call.request.queryParameters.getSearchParam(mapper)

			val events = eventService.getFutureEvents(call.user, searchParam)
			val totalEvents = eventService.countFutureEvents(call.user, searchParam)

			call.respond(TLists(events.map { TEventPartial(it) }, searchParam, totalEvents))
		}
	}

	private fun Route.getArchivedEvents() {
		get<Events.Archived> {
			val searchParam = call.request.queryParameters.getSearchParam(mapper)

			val events = eventService.getArchivedEvents(call.user, searchParam)
			val totalEvents = eventService.countArchivedEvents(call.user, searchParam)

			call.respond(TLists(events.map { TEventPartial(it) }, searchParam, totalEvents))
		}
	}

	private fun Route.getEventDetails() {
		get<Events.Id.Details> { id ->
			val (event, callerParticipation) = eventService.getEventWithParticipation(call.user, id.details.id)
				?: return@get call.respond(HttpStatusCode.NotFound, "L'évènement n'a pas été trouvé")

			val eventExpenses = callerParticipation?.let {
				expenseService.getEventExpense(it, call.user, event)
			}

			eventParticipationService.getParticipationsPreview(call.user, id.details.id)
				.onSuccess { (participants, participantsCount) ->
					call.respond(
						TEventDetails(
							event,
							callerParticipation,
							participants,
							participantsCount,
							eventExpenses
						)
					)
				}.onFailure {
					eventService.handleEventExceptions(it, call)
				}
		}
	}

	private fun Route.getEventExpenseReport() {
		get<Events.Id.Expenses.Report> { report ->
			val event = eventService.getEvent(call.user, report.expenses.id.id) ?: run {
				return@get call.respond(HttpStatusCode.NotFound, "L'évènement n'existe pas")
			}

			val callerParticipation = eventParticipationService.getParticipation(call.user, event.id.value).getOrElse {
				return@get eventService.handleEventExceptions(it, call)
			}

			val expenses = expenseService.getEventExpense(callerParticipation, call.user, event) ?: run {
				return@get call.respond(HttpStatusCode.NotFound, "Les dépenses n'ont pas été trouvé")
			}

			call.respondOutputStream(ContentType.Text.CSV) {
				write("name,description,amount,date\n".toByteArray(Charsets.UTF_8))
				expenses.forEach { e ->
					write("${e.name},\"${e.description}\",${e.amount},${e.date}\n".toByteArray(Charsets.UTF_8))
				}
			}
		}
	}

	private fun Route.getEvent() {
		get<Events.Id> { id ->
			val event = eventService.getEvent(call.user, id.id)
				?: return@get call.respond(HttpStatusCode.NotFound, "L'évènement n'a pas été trouvé")

			call.respond(TEvent(event, expenseService.authorizeBudget(call.user, event)))
		}
	}

	private fun Route.createEvent() {
		post<Events> {
			val newEvent = call.receive<TCreateEvent>()

			val association = newEvent.association?.let {
				associationService.getById(call.user, newEvent.association)
			} ?: call.user.association

			eventService.createEvent(
				call.user,
				newEvent.name,
				newEvent.description,
				newEvent.startDate,
				newEvent.endDate,
				association
			).onSuccess {
				call.respond(HttpStatusCode.Created, TEvent(it, expenseService.authorizeBudget(call.user, it)))
			}.onFailure {
				eventService.handleEventExceptions(it, call)
			}
		}
	}

	private fun Route.addJourneyToEvent() {
		post<Events.Id.Journey> { data ->
			val journeyId = call.receive<TAddJourneyToEvent>().journeyId

			eventService.addJourneyToEvent(
				call.user,
				data.journey.id,
				journeyId
			).onSuccess {
				call.respond(HttpStatusCode.OK)
			}.onFailure {
				eventService.handleEventExceptions(it, call)
			}
		}
	}

	private fun Route.removeJourneyFromEvent() {
		delete<Events.Id.Journey> { data ->
			eventService.removeJourneyFromEvent(
				call.user,
				data.journey.id,
			).onSuccess {
				call.respond(HttpStatusCode.OK)
			}.onFailure {
				eventService.handleEventExceptions(it, call)
			}
		}
	}

	private fun Route.updateEvent() {
		put<Events.Id> { id ->
			val updateEvent = call.receive<TUpdateEvent>()

			eventService.updateEvent(
				call.user,
				id.id,
				updateEvent.name,
				updateEvent.description,
				updateEvent.startDate,
				updateEvent.endDate,
				updateEvent.budget
			).onSuccess {
				call.respond(HttpStatusCode.OK, TEvent(it, expenseService.authorizeBudget(call.user, it)))
			}.onFailure {
				eventService.handleEventExceptions(it, call)
			}
		}
	}

	private fun Route.cancelEvent() {
		patch<Events.Id.Cancel> { id ->
			eventService.updateEventStatus(call.user, id.cancel.id, EEventStatus.Cancelled).onSuccess {
				call.respond(HttpStatusCode.OK)
			}.onFailure {
				eventService.handleEventExceptions(it, call)
			}
		}
	}

	private fun Route.scheduleEvent() {
		patch<Events.Id.Schedule> { id ->
			eventService.updateEventStatus(call.user, id.schedule.id, EEventStatus.Scheduled).onSuccess {
				call.respond(HttpStatusCode.OK)
			}.onFailure {
				eventService.handleEventExceptions(it, call)
			}
		}
	}

	private fun Route.finishEvent() {
		patch<Events.Id.Finish> { id ->
			eventService.updateEventStatus(call.user, id.finish.id, EEventStatus.Finished).onSuccess {
				call.respond(HttpStatusCode.OK)
			}.onFailure {
				eventService.handleEventExceptions(it, call)
			}
		}
	}

	private fun Route.pendEvent() {
		patch<Events.Id.Pend> { id ->
			eventService.updateEventStatus(call.user, id.pend.id, EEventStatus.Pending).onSuccess {
				call.respond(HttpStatusCode.OK)
			}.onFailure {
				eventService.handleEventExceptions(it, call)
			}
		}
	}

	private fun Route.uploadEventImage() {
		patch<Events.Id.UploadImage> { data ->
			val multipart = call.receiveMultipart()

			val image = multipart.readPart() as PartData.FileItem

			val contentType = checkContentType(image).getOrElse {
				return@patch call.respond(HttpStatusCode.BadRequest, it.message!!)
			}

			eventService.uploadEventImage(
				call.user,
				data.image.id,
				image.streamProvider().readBytes(),
				contentType.toString()
			).onSuccess {
				call.respond(TEvent(it, expenseService.authorizeBudget(call.user, it)))
			}.onFailure {
				eventService.handleEventExceptions(it, call)
			}
		}
	}

	private fun Route.deleteEvent() {
		delete<Events.Id> { id ->
			eventService.deleteEvent(call.user, id.id).onSuccess {
				call.respond(HttpStatusCode.OK)
			}.onFailure {
				eventService.handleEventExceptions(it, call)
			}
		}
	}

	private fun Route.getMetaData() {
		get<Events.MetaData>(EUserScope.Admin) {
			call.respond(mapper.getMapperData())
		}
	}

	private fun Route.terminateEventJourney() {
		post<Events.Id.Participations.Me.Journey.Terminate> {
			val event = eventService.getEvent(call.user, it.journey.me.participations.eventId.id) ?: run {
				call.respond(HttpStatusCode.NotFound, "Évènement inconnu")
				return@post
			}

			userEventPositionService.getUserJourney(call.user, event)?.let {
				call.respond(HttpStatusCode.Conflict, "Trajet déjà terminé")
			} ?: run {
				val journey = userEventPositionService.terminateUserJourney(call.user, event)
				call.respond(HttpStatusCode.Created, TUserJourney(journey))
			}
		}
	}

	private fun Route.removeEventJourney() {
		delete<Events.Id.Participations.Me.Journey> {
			val event = eventService.getEvent(call.user, it.me.participations.eventId.id) ?: run {
				call.respond(HttpStatusCode.NotFound, "Évènement inconnu")
				return@delete
			}

			userEventPositionService.removeUserJourney(call.user, event)
		}
	}

	private fun Route.getParticipantJourney() {
		get<Events.Id.Participations.User.Journey> {
			val event = eventService.getEvent(call.user, it.user.user.eventId.id) ?: run {
				call.respond(HttpStatusCode.NotFound, "Évènement inconnu")
				return@get
			}
			val user = userService.getUser(call.user, it.user.userId) ?: run {
				call.respond(HttpStatusCode.NotFound, "Utilisateur inconnu")
				return@get
			}

			val journey = userEventPositionService.getUserJourney(user, event) ?: run {
				call.respond(HttpStatusCode.NotFound, "Trajet non trouvé")
				return@get
			}

			call.respond(TUserJourney(journey))
		}
	}

	private suspend fun getParticipantJourneyFile(call: ApplicationCall, eventId: Int, userId: Int) {
		val event = eventService.getEvent(call.user, eventId) ?: run {
			call.respond(HttpStatusCode.NotFound, "Évènement inconnu")
			return
		}
		val user = userService.getUser(call.user, userId) ?: run {
			call.respond(HttpStatusCode.NotFound, "Utilisateur inconnu")
			return
		}

		val journey = userEventPositionService.getUserJourney(user, event) ?: run {
			call.respond(HttpStatusCode.NotFound, "Trajet non trouvé")
			return
		}

		val data = storageService.retrieve(journey.journey) ?: run {
			return call.respond(HttpStatusCode.NotFound, "Le fichier n'existe pas")
		}

		val geojson = json.decodeFromString<GeoJson>(data.toString(Charsets.UTF_8))

		if (call.request.accept()?.contains("geo+json") == true) {
			call.respond(json.encodeToString(geojson))
		} else if (call.request.accept()?.contains("gpx") == true) {
			call.respond(xml.encodeToString(geojson.toGpx()))
		} else {
			call.respond(HttpStatusCode.BadRequest, "Il manque un format de retour")
		}
	}

	private fun Route.getMyJourneyFile() {
		get<Events.Id.Participations.Me.Journey.File> {
			getParticipantJourneyFile(call, it.journey.me.participations.eventId.id, call.user.id.value)
		}
	}

	private fun Route.getParticipantJourneyFile() {
		get<Events.Id.Participations.User.Journey.File> {
			getParticipantJourneyFile(call, it.journey.user.user.eventId.id, it.journey.user.userId)
		}
	}
}