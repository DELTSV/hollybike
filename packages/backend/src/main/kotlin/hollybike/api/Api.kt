package hollybike.api

import hollybike.api.repository.configureDatabase
import hollybike.api.routing.controller.ApiController
import io.ktor.server.application.*
import io.ktor.server.plugins.callloging.*
import io.ktor.server.resources.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import io.ktor.util.*
import kotlinx.serialization.Serializable
import kotlinx.serialization.json.Json
import org.slf4j.event.Level
import java.io.File

val confKey = AttributeKey<Conf>("hollybikeConf")

val Attributes.conf get() = this[confKey]

fun Application.api() {
	this.attributes.put(confKey, parseConf())
	configureDatabase()
	install(Resources)
	install(CallLogging) {
		this.level = Level.INFO
	}
	ApiController(this)
}