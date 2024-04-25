package hollybike.api.routing.controller

import hollybike.api.plugins.user
import hollybike.api.routing.resources.Users
import hollybike.api.services.UserService
import hollybike.api.types.user.TUser
import io.ktor.http.*
import io.ktor.http.content.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.request.*
import io.ktor.server.resources.*
import io.ktor.server.resources.post
import io.ktor.server.response.*
import io.ktor.server.routing.*

class UserController(
	application: Application,
	private val userService: UserService,
) {
	init {
		application.routing {
			authenticate {
				getMe()
				getUserById()
				uploadProfilePicture()
			}
		}
	}

	private fun Route.getMe() {
		get<Users.Me> {
			call.respond(TUser(call.user))
		}
	}

	private fun Route.getUserById() {
		get<Users.Id> {
			userService.getUser(call.user, it.id)?.let { user ->
				call.respond(TUser(user))
			} ?: run {
				call.respond(HttpStatusCode.NotFound, "User not found")
			}
		}
	}

	private fun Route.uploadProfilePicture() {
		post<Users.UploadProfilePicture> {
			val multipart = call.receiveMultipart()

			val user = call.user
			val image = multipart.readPart() as PartData.FileItem

			val contentType = image.contentType ?: run {
				call.respond(HttpStatusCode.BadRequest, "Missing image content type")
				return@post
			}

			if (!contentType.match(ContentType.Image.JPEG) && !contentType.match(ContentType.Image.PNG)) {
				call.respond(HttpStatusCode.BadRequest, "Invalid image content type (only JPEG and PNG are supported)")
				return@post
			}

			userService.uploadUserProfilePicture(user, image.streamProvider().readBytes(), contentType.toString())

			call.respond(HttpStatusCode.OK)
		}
	}
}
