package hollybike.api

import io.ktor.serialization.kotlinx.json.*
import io.ktor.server.application.*
import io.ktor.server.cio.*
import io.ktor.server.engine.*
import io.ktor.server.plugins.contentnegotiation.*
import kotlinx.serialization.json.Json

fun main() {
	embeddedServer(CIO, port = 8080, host = "0.0.0.0", watchPaths = listOf("classes", "resources"), module = Application::module).start(wait = true)
}

fun Application.module() {
	configureSerialization()
	frontend()
	api()
}

fun Application.configureSerialization() {
	install(ContentNegotiation) {
		json(Json {
			prettyPrint = true
			ignoreUnknownKeys = true
		})
	}
}