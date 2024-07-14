package hollybike.api

import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.http.content.*
import io.ktor.server.request.*
import io.ktor.server.response.*
import io.ktor.server.routing.*

fun Application.frontend() {
	if (isOnPremise) {
		routing {
			get("/{...}") {
				if(call.request.uri.endsWith(".png")) {
					this::class.java.getResource("/front${call.request.uri}")?.readBytes()?.let {
						call.respondBytes(it, ContentType.Image.PNG)
					}
				}else if(call.request.uri.endsWith(".jpg")) {
					this::class.java.getResource("/front${call.request.uri}")?.readBytes()?.let {
						call.respondBytes(it, ContentType.Image.JPEG)
					}
				} else {
					println("INDEX ${call.request.uri}")
					this::class.java.getResource("/front/index.html")?.readText()?.let {
						call.respondText(it, ContentType.Text.Html)
					}
				}
			}
			staticResources("/assets", "front/assets")
			staticResources("/", "front")
		}
	}
}