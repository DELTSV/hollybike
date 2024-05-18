package hollybike.api

import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.http.content.*
import io.ktor.server.response.*
import io.ktor.server.routing.*

fun Application.frontend() {
	if (isOnPremise) {
		routing {
			get("/{...}") {
				this::class.java.getResource("/front/index.html")?.readText()?.let {
					call.respondText(it, ContentType.Text.Html)
				}
			}
			staticResources("/assets", "front/assets")
		}
	}
}