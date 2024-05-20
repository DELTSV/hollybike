package hollybike.api

import hollybike.api.plugins.configureHTTP
import hollybike.api.routing.controller.ApiController
import io.ktor.server.application.*
import io.ktor.server.plugins.callloging.*
import io.ktor.server.resources.*
import org.slf4j.event.Level

fun Application.confMode() {
	configureHTTP()
	install(Resources)
	install(CallLogging) {
		this.level = Level.INFO
	}
	ApiController(this, null, false)
}