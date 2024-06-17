package hollybike.api.routing.controller

import hollybike.api.plugins.user
import hollybike.api.repository.Event
import hollybike.api.repository.associationMapper
import hollybike.api.repository.eventMapper
import hollybike.api.repository.userMapper
import hollybike.api.routing.resources.Events
import hollybike.api.services.AssociationService
import hollybike.api.services.EventParticipationService
import hollybike.api.services.EventService
import hollybike.api.services.storage.StorageService
import hollybike.api.types.event.*
import hollybike.api.types.lists.TLists
import hollybike.api.types.user.EUserScope
import hollybike.api.utils.checkContentType
import hollybike.api.utils.get
import hollybike.api.utils.search.SearchParam
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
import kotlin.math.ceil

class EventController(
	application: Application,
	private val eventService: EventService,
	private val eventParticipationService: EventParticipationService,
	private val associationService: AssociationService
) {
	private val mapper = eventMapper + associationMapper + userMapper

	init {
		application.routing {
			authenticate {
				getAllEvents()
				getFutureEvents()
				getArchivedEvents()
				getEventDetails()
				getEvent()
				createEvent()
				addJourneyToEvent()
				updateEvent()
				uploadEventImage()
				deleteEvent()
				cancelEvent()
				scheduleEvent()
				finishEvent()
				pendEvent()
				getMetaData()
			}
		}
	}

	private fun getEventsPagination(events: List<Event>, total: Int, searchParam: SearchParam): TLists<TEventPartial> {
		return TLists(
			data = events.map { TEventPartial(it) },
			page = searchParam.page,
			perPage = searchParam.perPage,
			totalPage = ceil(total.toDouble() / searchParam.perPage).toInt(),
			totalData = total
		)
	}

	private fun Route.getAllEvents() {
		get<Events> {
			val params = call.request.queryParameters.getSearchParam(mapper)

			val events = eventService.getAllEvents(call.user, params)
			val totalEvents = eventService.countAllEvents(call.user, params)

			call.respond(getEventsPagination(events, totalEvents, params))
		}
	}

	private fun Route.getFutureEvents() {
		get<Events.Future> {
			val searchParam = call.request.queryParameters.getSearchParam(mapper)

			val events = eventService.getFutureEvents(call.user, searchParam)
			val totalEvents = eventService.countFutureEvents(call.user, searchParam)

			call.respond(getEventsPagination(events, totalEvents, searchParam))
		}
	}

	private fun Route.getArchivedEvents() {
		get<Events.Archived> {
			val searchParam = call.request.queryParameters.getSearchParam(mapper)

			val events = eventService.getArchivedEvents(call.user, searchParam)
			val totalEvents = eventService.countArchivedEvents(call.user, searchParam)

			call.respond(getEventsPagination(events, totalEvents, searchParam))
		}
	}

	private fun Route.getEventDetails() {
		get<Events.Id.Details> { id ->
			val (event, callerParticipation) = eventService.getEventWithParticipation(call.user, id.details.id)
				?: return@get call.respond(HttpStatusCode.NotFound, "Event not found")

			eventParticipationService.getParticipationsPreview(call.user, id.details.id)
				.onSuccess { (participants, participantsCount) ->
					call.respond(
						TEventDetails(
							event,
							callerParticipation,
							participants,
							participantsCount
						)
					)
				}.onFailure {
					eventService.handleEventExceptions(it, call)
				}
		}
	}

	private fun Route.getEvent() {
		get<Events.Id> { id ->
			val event = eventService.getEvent(call.user, id.id)
				?: return@get call.respond(HttpStatusCode.NotFound, "Event not found")

			call.respond(TEvent(event))
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
				call.respond(HttpStatusCode.Created, TEvent(it))
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

	private fun Route.updateEvent() {
		put<Events.Id> { id ->
			val updateEvent = call.receive<TUpdateEvent>()

			eventService.updateEvent(
				call.user,
				id.id,
				updateEvent.name,
				updateEvent.description,
				updateEvent.startDate,
				updateEvent.endDate
			).onSuccess {
				call.respond(HttpStatusCode.OK, TEvent(it))
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
				call.respond(TEvent(it))
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
}