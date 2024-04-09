package hollybike.api

import io.ktor.server.application.*
import io.ktor.server.response.*
import io.ktor.server.routing.*

fun Application.api() {
	routing {
		route("/api") {
			get {
				call.respond("Bienvenue sur l'API Hollybike")
			}
		}
	}
}