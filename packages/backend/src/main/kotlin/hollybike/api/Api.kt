package hollybike.api

import hollybike.api.plugins.configureHTTP
import hollybike.api.plugins.configureSecurity
import hollybike.api.repository.configureDatabase
import hollybike.api.routing.controller.ApiController
import hollybike.api.routing.controller.AuthenticationController
import io.ktor.server.application.*
import io.ktor.server.plugins.callloging.*
import io.ktor.server.resources.*
import io.ktor.util.*
import org.slf4j.event.Level

val confKey = AttributeKey<Conf>("hollybikeConf")

val Attributes.conf get() = this[confKey]

fun Application.api() {
	this.attributes.put(confKey, parseConf())
	configureDatabase()
	configureHTTP()
	configureSecurity()
	install(Resources)
	install(CallLogging) {
		this.level = Level.INFO
	}
	ApiController(this)
	AuthenticationController(this)
}