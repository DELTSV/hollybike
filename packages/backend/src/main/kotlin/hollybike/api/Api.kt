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

@Serializable
data class Conf(
	val db: ConfDB
)

@Serializable
data class ConfDB(
	val url: String,
	val username: String,
	val password: String
)

fun parseConf(): Conf {
	val f = File("./app.json")
	val json = Json {
		ignoreUnknownKeys = true
	}
	val conf = json.decodeFromString<Conf>(f.readText())
	return conf
}