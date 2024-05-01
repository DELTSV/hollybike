package hollybike.api.routing.controller

import hollybike.api.routing.resources.API
import hollybike.api.utils.MailSender
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.resources.*
import io.ktor.server.response.*
import io.ktor.server.routing.*

class ApiController(
	application: Application,
	private val mailSender: MailSender?,
) {
	init {
		application.routing {
			index()
			notFound()
			getSMTPStatus()
		}
	}

	private fun Route.index() {
		get<API> {
			call.respondText("Bienvenue sur l'API hollyBike")
		}
	}

	private fun Route.notFound() {
		get<API.NotFound> {
			call.respondText("Path ${it.path} not Found", status = HttpStatusCode.NotFound)
		}
	}

	private fun Route.getSMTPStatus() {
		get<API.SMTP> {
			if(mailSender == null) {
				call.respond(HttpStatusCode.ServiceUnavailable, "SMTP Service unavailable, configure smtp to have access to these functionality")
			} else {
				call.respond(HttpStatusCode.OK)
			}
		}
	}
}