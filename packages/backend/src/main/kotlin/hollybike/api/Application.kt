package hollybike.api

import hollybike.api.plugins.*
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.cio.*
import io.ktor.server.engine.*
import io.ktor.server.http.content.*
import io.ktor.server.response.*
import io.ktor.server.routing.*

fun main() {
	embeddedServer(CIO, port = 8080, host = "0.0.0.0", module = Application::module)
		.start(wait = true)
}

fun Application.module() {
	configureSockets()
	configureSerialization()
	configureHTTP()
	configureSecurity()

	routing {
		route("/api") {
			get("/test") {
				println("ICI")
				call.respondText("HELLO WORLD!")
			}
		}
		get("/{...}") {
			this::class.java.getResource("/front/index.html")?.readText()?.let {
				call.respondText(it, ContentType.Text.Html)
			}
		}
		staticResources("/assets", "front/assets")
	}
}
