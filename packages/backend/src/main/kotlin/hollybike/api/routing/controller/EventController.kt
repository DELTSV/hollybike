package hollybike.api.routing.controller

import hollybike.api.routing.resources.Events
import hollybike.api.services.EventService
import hollybike.api.types.event.TEvent
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.resources.*
import io.ktor.server.response.*
import io.ktor.server.routing.*

class EventController(
	application: Application,
	private val eventService: EventService,
) {
	init {
		application.routing {
			authenticate {
				getEvents()
			}
		}
	}

	private fun Route.getEvents() {
		get<Events> {
			call.respond(eventService.getEvents().map { TEvent(it) })
		}
	}
}