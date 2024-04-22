package hollybike.api.routing.controller

import hollybike.api.plugins.user
import hollybike.api.routing.resources.Users
import hollybike.api.services.UserService
import hollybike.api.types.user.EUserScope
import hollybike.api.types.user.TUser
import hollybike.api.utils.get
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.resources.*
import io.ktor.server.response.*
import io.ktor.server.routing.*

class UserController(
	application: Application,
	private val userService: UserService
) {
	init {
		application.routing {
			authenticate {
				getMe()
				getUserById()
			}
		}
	}

	private fun Route.getMe() {
		get<Users.Me> {
			println(call.user.association)
			call.respond(TUser(call.user))
		}
	}

	private fun Route.getUserById() {
		get<Users.Id>(EUserScope.Admin) {
			userService.getUser(call.user, it.id)?.let { user ->
				call.respond(TUser(user))
			} ?: run {
				call.respond(HttpStatusCode.NotFound, "User not found")
			}
		}
	}
}