package hollybike.api.routing.controller

import hollybike.api.routing.resources.API
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.resources.*
import io.ktor.server.response.*
import io.ktor.server.routing.*

class ApiController(
	application: Application
) {
	init {
		application.routing {
			index()
			notFound()
		}
	}

	private fun Route.index() {
		get<API> {
			call.respondText("Bienvenue sur l'API hollybike")
		}
	}

	private fun Route.notFound() {
		get<API.NotFound> {
			call.respondText("Path ${it.path} not Found", status = HttpStatusCode.NotFound)
		}
	}
}