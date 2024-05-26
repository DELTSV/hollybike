package hollybike.api.routing.controller

import hollybike.api.exceptions.*
import hollybike.api.plugins.user
import hollybike.api.repository.associationMapper
import hollybike.api.repository.events.eventMapper
import hollybike.api.repository.userMapper
import hollybike.api.routing.resources.Events
import hollybike.api.services.EventService
import hollybike.api.types.event.*
import hollybike.api.types.lists.TLists
import hollybike.api.utils.listParams
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
	private val host: String
) {
	init {
		application.routing {
			authenticate {
				getEvents()
				getEvent()
				createEvent()
				updateEvent()
				uploadEventImage()
				deleteEvent()
				participateEvent()
				leaveEvent()
				promoteParticipant()
				demoteParticipant()
				cancelEvent()
				scheduleEvent()
				finishEvent()
				pendEvent()
			}
		}
	}

	private suspend fun handleEventExceptions(exception: Throwable, call: ApplicationCall) {
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

	private fun Route.getEvents() {
		get<Events> {
			val params = call.request.queryParameters.getSearchParam(eventMapper + associationMapper + userMapper)

			val events = eventService.getEvents(call.user, params)
			val total = eventService.countEvents(call.user, params)

			call.respond(
				TLists(
					data = events.map { TEventPartial(it, host) },
					page = call.listParams.page,
					perPage = call.listParams.perPage,
					totalPage = ceil(total.toDouble() / call.listParams.perPage).toInt(),
					totalData = total
				)
			)
		}
	}

	private fun Route.getEvent() {
		get<Events.Id> { id ->
			val event = eventService.getEvent(call.user, id.id)
				?: return@get call.respond(HttpStatusCode.NotFound, "Event not found")

			call.respond(TEvent(event, host))
		}
	}

	private fun Route.createEvent() {
		post<Events> {
			val newEvent = call.receive<TCreateEvent>()

			eventService.createEvent(
				call.user,
				newEvent.name,
				newEvent.description,
				newEvent.startDate,
				newEvent.endDate
			).onSuccess {
				call.respond(HttpStatusCode.Created, TEvent(it.first, host, listOf(it.second)))
			}.onFailure {
				handleEventExceptions(it, call)
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
				call.respond(HttpStatusCode.OK, TEvent(it, host))
			}.onFailure {
				handleEventExceptions(it, call)
			}
		}
	}

	private fun Route.cancelEvent() {
		patch<Events.Id.Cancel> { id ->
			eventService.updateEventStatus(call.user, id.cancel.id, EEventStatus.Cancelled).onSuccess {
				call.respond(HttpStatusCode.OK)
			}.onFailure {
				handleEventExceptions(it, call)
			}
		}
	}

	private fun Route.scheduleEvent() {
		patch<Events.Id.Schedule> { id ->
			eventService.updateEventStatus(call.user, id.schedule.id, EEventStatus.Scheduled).onSuccess {
				call.respond(HttpStatusCode.OK)
			}.onFailure {
				handleEventExceptions(it, call)
			}
		}
	}

	private fun Route.finishEvent() {
		patch<Events.Id.Finish> { id ->
			eventService.updateEventStatus(call.user, id.finish.id, EEventStatus.Finished).onSuccess {
				call.respond(HttpStatusCode.OK)
			}.onFailure {
				handleEventExceptions(it, call)
			}
		}
	}

	private fun Route.pendEvent() {
		patch<Events.Id.Pend> { id ->
			eventService.updateEventStatus(call.user, id.pend.id, EEventStatus.Pending).onSuccess {
				call.respond(HttpStatusCode.OK)
			}.onFailure {
				handleEventExceptions(it, call)
			}
		}
	}

	private fun Route.uploadEventImage() {
		patch<Events.Id.UploadImage> { data ->
			val multipart = call.receiveMultipart()

			val image = multipart.readPart() as PartData.FileItem

			val contentType = image.contentType ?: run {
				call.respond(HttpStatusCode.BadRequest, "Type de contenu de l'image manquant")
				return@patch
			}

			if (contentType != ContentType.Image.JPEG && contentType != ContentType.Image.PNG) {
				call.respond(HttpStatusCode.BadRequest, "Image invalide (JPEG et PNG seulement)")
				return@patch
			}

			eventService.uploadEventImage(
				call.user,
				data.image.id,
				image.streamProvider().readBytes(),
				contentType.toString()
			).onSuccess {
				call.respond(TEvent(it, host))
			}.onFailure {
				handleEventExceptions(it, call)
			}
		}
	}

	private fun Route.deleteEvent() {
		delete<Events.Id> { id ->
			eventService.deleteEvent(call.user, id.id).onSuccess {
				call.respond(HttpStatusCode.OK)
			}.onFailure {
				handleEventExceptions(it, call)
			}
		}
	}

	private fun Route.participateEvent() {
		post<Events.Id.Participations> { data ->
			eventService.participateEvent(call.user, data.participations.id).onSuccess {
				call.respond(HttpStatusCode.Created, TEventParticipation(it))
			}.onFailure {
				handleEventExceptions(it, call)
			}
		}
	}

	private fun Route.leaveEvent() {
		delete<Events.Id.Participations> { data ->
			eventService.leaveEvent(call.user, data.participations.id).onSuccess {
				call.respond(HttpStatusCode.OK)
			}.onFailure {
				handleEventExceptions(it, call)
			}
		}
	}

	private fun Route.promoteParticipant() {
		patch<Events.Id.Participations.User.Promote> { data ->
			eventService.promoteParticipant(call.user, data.promote.user.participations.id, data.promote.userId)
				.onSuccess {
					call.respond(HttpStatusCode.OK, TEventParticipation(it))
				}.onFailure {
					handleEventExceptions(it, call)
				}
		}
	}

	private fun Route.demoteParticipant() {
		patch<Events.Id.Participations.User.Demote> { data ->
			eventService.demoteParticipant(call.user, data.demote.user.participations.id, data.demote.userId)
				.onSuccess {
					call.respond(HttpStatusCode.OK, TEventParticipation(it))
				}.onFailure {
					handleEventExceptions(it, call)
				}
		}
	}
}