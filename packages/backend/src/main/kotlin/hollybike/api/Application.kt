package hollybike.api

import hollybike.api.plugins.*
import io.ktor.server.application.*
import io.ktor.server.cio.*
import io.ktor.server.engine.*
import io.ktor.server.http.content.*
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
	configureRouting()

	routing {
		singlePageApplication {
			useResources = true
			filesPath = "sample-web-app"
			defaultPage = "main.html"
			ignoreFiles { it.endsWith(".txt") }
		}
	}
}
