package hollybike.api

import hollybike.api.repository.configureDatabase
import io.ktor.server.application.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import io.ktor.util.*
import kotlinx.serialization.Serializable
import kotlinx.serialization.json.Json
import java.io.File

val confKey = AttributeKey<Conf>("hollybikeConf")

val Attributes.conf get() = this[confKey]

fun Application.api() {
	this.attributes.put(confKey, parseConf())
	configureDatabase()
	routing {
		route("/api") {
			get {
				call.respondText("Bienvenue sur l'API Hollybike")
			}
		}
	}
}