/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.routing.controller

import hollybike.api.isOnPremise
import hollybike.api.routing.resources.API
import hollybike.api.types.api.TConfDone
import hollybike.api.types.api.TOnPremise
import hollybike.api.utils.MailSender
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.resources.*
import io.ktor.server.response.*
import io.ktor.server.routing.*

class ApiController(
	application: Application,
	private val mailSender: MailSender?,
	private val confDone: Boolean
) {
	init {
		application.routing {
			index()
			notFound()
			getSMTPStatus()
			getConfDone()
			getOnPremise()
		}
	}

	private fun Route.index() {
		get<API> {
			call.respondText("Bienvenue sur l'API hollyBike")
		}
	}

	private fun Route.notFound() {
		get<API.NotFound> {
			call.respondText("Chemin ${it.path.joinToString("/")} inconnu", status = HttpStatusCode.NotFound)
		}
	}

	private fun Route.getSMTPStatus() {
		get<API.SMTP> {
			if(mailSender == null) {
				call.respond(HttpStatusCode.ServiceUnavailable, "Service SMTP indisponible, configurer un server SMTP pour accéder à cette fonctionnalité")
			} else {
				call.respond(HttpStatusCode.OK)
			}
		}
	}

	private fun Route.getConfDone() {
		get<API.ConfDone> {
			call.respond(TConfDone(confDone))
		}
	}

	private fun Route.getOnPremise() {
		get<API.OnPremise> {
			call.respond(TOnPremise(application.isOnPremise))
		}
	}
}