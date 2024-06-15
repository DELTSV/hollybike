package hollybike.api.utils

import hollybike.api.isOnPremise
import hollybike.api.routing.resources.API
import hollybike.api.types.user.EUserScope
import io.ktor.events.*
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.resources.*
import io.ktor.server.response.*
import io.ktor.server.routing.*

fun Application.configureRestart(confMode: Boolean) {
	if(isOnPremise) {
		routing {
			if(!confMode) {
				authenticate {
					delete<API.Restart>(EUserScope.Admin) {
						val application = call.application
						val environment = application.environment
						call.respond(HttpStatusCode.Gone)
						environment.monitor.raiseCatching(ApplicationStopPreparing, environment, application.log)
					}
				}
			} else {
				delete<API.Restart> {
					val application = call.application
					val environment = application.environment
					call.respond(HttpStatusCode.Gone)
					environment.monitor.raiseCatching(ApplicationStopPreparing, environment, application.log)
				}
			}
		}
	}
}