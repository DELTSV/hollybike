package hollybike.api.routing.controller

import hollybike.api.plugins.user
import hollybike.api.routing.resources.Events
import hollybike.api.services.EventService
import hollybike.api.types.event.TEvent
import hollybike.api.types.lists.TLists
import hollybike.api.utils.listParams
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.resources.*
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
					data = events.map { TEvent(it) },
					page = call.listParams.page,
					perPage = call.listParams.perPage,
					totalPage = ceil(total.toDouble() / call.listParams.perPage).toInt(),
					totalData = total
				)
			)
		}
	}
}