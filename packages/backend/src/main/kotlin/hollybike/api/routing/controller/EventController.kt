package hollybike.api.routing.controller

import hollybike.api.exceptions.events.AlreadyParticipatingToEvent
import hollybike.api.exceptions.events.EventNotFound
import hollybike.api.exceptions.events.NotParticipatingToEvent
import hollybike.api.plugins.user
import hollybike.api.routing.resources.Events
import hollybike.api.services.EventService
import hollybike.api.types.event.TEvent
import hollybike.api.types.event.TEventPartial
import hollybike.api.types.event.TEventParticipation
import hollybike.api.types.lists.TLists
import hollybike.api.utils.listParams
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.plugins.*
import io.ktor.server.resources.*
import io.ktor.server.resources.post
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
				participateEvent()
				leaveEvent()
				promoteParticipant()
				demoteParticipant()
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

//	private fun Route.createEvent() {
//		post<Events> { data ->
//			eventService.createEvent(call.user, data.event).onSuccess {
//				call.respond(HttpStatusCode.Created, TEvent(it))
//			}.onFailure {
//				when (it) {
//					is Exception -> {
//						it.printStackTrace()
//						call.respond(HttpStatusCode.InternalServerError, "Internal server error")
//					}
//				}
//			}
//		}
//	}

	private fun Route.getEvent() {
		get<Events.Id> { id ->
			val event = eventService.getEvent(call.user, id.id)
				?: throw NotFoundException("Event not found")

			call.respond(TEvent(event))
		}
	}

	private fun Route.participateEvent() {
		post<Events.Id.Participations> { data ->
			eventService.participateEvent(call.user, data.participations.id).onSuccess {
				call.respond(HttpStatusCode.Created, TEventParticipation(it))
			}.onFailure {
				when (it) {
					is EventNotFound -> call.respond(HttpStatusCode.NotFound, "Event not found")
					is AlreadyParticipatingToEvent -> call.respond(
						HttpStatusCode.Conflict,
						"Already participating to this event"
					)

					is Exception -> {
						it.printStackTrace()
						call.respond(HttpStatusCode.InternalServerError, "Internal server error")
					}
				}
			}
		}
	}

	private fun Route.leaveEvent() {
		delete<Events.Id.Participations> { data ->
			eventService.leaveEvent(call.user, data.participations.id).onSuccess {
				call.respond(HttpStatusCode.OK)
			}.onFailure {
				when (it) {
					is EventNotFound -> call.respond(HttpStatusCode.NotFound, "Event not found")
					is NotParticipatingToEvent -> call.respond(
						HttpStatusCode.BadRequest,
						"Not participating to this event"
					)

					is Exception -> {
						it.printStackTrace()
						call.respond(HttpStatusCode.InternalServerError, "Internal server error")
					}
				}
			}
		}
	}

	private fun Route.promoteParticipant() {
		post<Events.Id.Participations.User.Promote> { data ->
			eventService.promoteParticipant(call.user, data.promote.user.participations.id, data.promote.userId)
				.onSuccess {
					call.respond(HttpStatusCode.OK, TEventParticipation(it))
				}.onFailure {
					when (it) {
						is EventNotFound -> call.respond(HttpStatusCode.NotFound, "Event not found")
						is NotParticipatingToEvent -> call.respond(
							HttpStatusCode.BadRequest,
							"Not participating to this event"
						)

						is Exception -> {
							it.printStackTrace()
							call.respond(HttpStatusCode.InternalServerError, "Internal server error")
						}
					}
				}
		}
	}

	private fun Route.demoteParticipant() {
		delete<Events.Id.Participations.User.Promote> { data ->
			eventService.demoteParticipant(call.user, data.promote.user.participations.id, data.promote.userId)
				.onSuccess {
					call.respond(HttpStatusCode.OK, TEventParticipation(it))
				}.onFailure {
					when (it) {
						is EventNotFound -> call.respond(HttpStatusCode.NotFound, "Event not found")
						is NotParticipatingToEvent -> call.respond(
							HttpStatusCode.BadRequest,
							"Not participating to this event"
						)

						is Exception -> {
							it.printStackTrace()
							call.respond(HttpStatusCode.InternalServerError, "Internal server error")
						}
					}
				}
		}
	}
}