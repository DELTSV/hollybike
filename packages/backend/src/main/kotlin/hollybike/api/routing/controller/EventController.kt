package hollybike.api.routing.controller

import hollybike.api.exceptions.*
import hollybike.api.plugins.user
import hollybike.api.routing.resources.Events
import hollybike.api.services.EventService
import hollybike.api.types.event.*
import hollybike.api.types.lists.TLists
import hollybike.api.utils.listParams
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
			is EventNotFoundException -> call.respond(HttpStatusCode.NotFound, "Event not found")
			is EventActionDeniedException -> call.respond(
				HttpStatusCode.Forbidden,
				exception.message ?: "Action denied"
			)

			is InvalidDateException -> call.respond(HttpStatusCode.BadRequest, exception.message ?: "Invalid date")
			is InvalidEventNameException -> call.respond(
				HttpStatusCode.BadRequest,
				exception.message ?: "Invalid event name"
			)

			is InvalidEventDescriptionException -> call.respond(
				HttpStatusCode.BadRequest,
				exception.message ?: "Invalid event description"
			)

			else -> {
				exception.printStackTrace()
				call.respond(HttpStatusCode.InternalServerError, "Internal server error")
			}
		}
	}

	private fun Route.getEvents() {
		get<Events> {
			val events = eventService.getEvents(
				call.user,
				call.listParams.perPage,
				call.listParams.page
			)

			val total = eventService.countEvents(call.user)

			call.respond(
				TLists(
					data = events.map { TEventPartial(it) },
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

			call.respond(TEvent(event))
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
				call.respond(HttpStatusCode.Created, TEvent(it.first, listOf(it.second)))
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
				call.respond(HttpStatusCode.OK, TEvent(it))
			}.onFailure {
				handleEventExceptions(it, call)
			}
		}
	}

	private fun Route.cancelEvent() {
		patch<Events.Id.Cancel> { id ->
			eventService.updateEventStatus(call.user, id.cancel.id, EEventStatus.CANCELLED).onSuccess {
				call.respond(HttpStatusCode.OK)
			}.onFailure {
				handleEventExceptions(it, call)
			}
		}
	}

	private fun Route.scheduleEvent() {
		patch<Events.Id.Schedule> { id ->
			eventService.updateEventStatus(call.user, id.schedule.id, EEventStatus.SCHEDULED).onSuccess {
				call.respond(HttpStatusCode.OK)
			}.onFailure {
				handleEventExceptions(it, call)
			}
		}
	}

	private fun Route.finishEvent() {
		patch<Events.Id.Finish> { id ->
			eventService.updateEventStatus(call.user, id.finish.id, EEventStatus.FINISHED).onSuccess {
				call.respond(HttpStatusCode.OK)
			}.onFailure {
				handleEventExceptions(it, call)
			}
		}
	}

	private fun Route.pendEvent() {
		patch<Events.Id.Pend> { id ->
			eventService.updateEventStatus(call.user, id.pend.id, EEventStatus.PENDING).onSuccess {
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
				call.respond(HttpStatusCode.BadRequest, "Missing image content type")
				return@patch
			}

			if (contentType != ContentType.Image.JPEG && contentType != ContentType.Image.PNG) {
				call.respond(HttpStatusCode.BadRequest, "Invalid image content type (only JPEG and PNG are supported)")
				return@patch
			}

			eventService.uploadEventImage(
				call.user,
				data.image.id,
				image.streamProvider().readBytes(),
				contentType.toString()
			).onSuccess {
				call.respond(TEvent(it))
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