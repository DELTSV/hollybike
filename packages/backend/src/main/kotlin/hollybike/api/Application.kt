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
	embeddedServer(CIO, applicationEngineEnvironment { env() }).start(wait = true)
}

fun ApplicationEngineEnvironmentBuilder.env() {
	module {
		module()
	}
	connector {
		host = "0.0.0.0"
		port = 8080
	}
	developmentMode = true
}

fun Application.module() {
	configureSockets()
	configureSerialization()
	configureHTTP()
	configureSecurity()
	serveFront()
	routing {
		route("/api") {
			get {
				call.respondText("HELLO WORLD!")
			}
		}
	}
}

fun Application.serveFront() {
	routing {
		get("/{...}") {
			this::class.java.getResource("/front/index.html")?.readText()?.let {
				call.respondText(it, ContentType.Text.Html)
			}
		}
		staticResources("/assets", "front/assets")
	}
}