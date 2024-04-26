package hollybike.api.routing.controller

import hollybike.api.exceptions.BadRequestException
import hollybike.api.exceptions.UserDifferentNewPassword
import hollybike.api.exceptions.UserWrongPassword
import hollybike.api.plugins.user
import hollybike.api.routing.resources.Users
import hollybike.api.services.UserService
import hollybike.api.types.user.EUserScope
import hollybike.api.types.user.TUser
import hollybike.api.types.user.TUserUpdateSelf
import hollybike.api.utils.get
import hollybike.api.utils.post
import io.ktor.http.*
import io.ktor.http.content.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.request.*
import io.ktor.server.resources.*
import io.ktor.server.resources.post
import io.ktor.server.response.*
import io.ktor.server.routing.routing
import io.ktor.server.routing.Route

class UserController(
	application: Application,
	private val userService: UserService,
) {
	init {
		application.routing {
			authenticate {
				getMe()
				getUserById()
				getByUserName()
				getByEmail()
				updateMe()
				uploadMeProfilePicture()
				uploadUserProfilePicture()
			}
		}
	}

	private fun Route.getMe() {
		get<Users.Me> {
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

	private fun Route.getByUserName() {
		get<Users.Username> {
			userService.getUserByUsername(call.user, it.username)?.let { user ->
				call.respond(TUser(user))
			} ?: run {
				call.respond(HttpStatusCode.NotFound, "User not found")
			}
		}
	}

	private fun Route.getByEmail() {
		get<Users.Email> {
			userService.getUserByEmail(call.user, it.email)?.let { user ->
				call.respond(TUser(user))
			} ?: run {
				call.respond(HttpStatusCode.NotFound, "User not found")
			}
		}
	}

	private fun Route.updateMe() {
		this.patch<Users.Me> {
			val update = call.receive<TUserUpdateSelf>()
			userService.updateMe(call.user, update).onSuccess {
				call.respond(TUser(it))
			}.onFailure {
				when(it) {
					is BadRequestException -> call.respond(HttpStatusCode.BadRequest, "Change password need new_password, new_password_again and old_password")
					is UserWrongPassword -> call.respond(HttpStatusCode.Unauthorized, "Wrong old_password")
					is UserDifferentNewPassword -> call.respond(HttpStatusCode.BadRequest, "new_password and _new_password_again are different")
				}
			}
		}
	}

	private fun Route.uploadMeProfilePicture() {
		post<Users.Me.UploadProfilePicture> {
			val multipart = call.receiveMultipart()

			val image = multipart.readPart() as PartData.FileItem

			val contentType = image.contentType ?: run {
				call.respond(HttpStatusCode.BadRequest, "Missing image content type")
				return@post
			}

			if (contentType != ContentType.Image.JPEG && contentType != ContentType.Image.PNG) {
				call.respond(HttpStatusCode.BadRequest, "Invalid image content type (only JPEG and PNG are supported)")
				return@post
			}

			userService.uploadUserProfilePicture(call.user, call.user, image.streamProvider().readBytes(), contentType.toString())

			call.respond(HttpStatusCode.OK)
		}
	}

	private fun Route.uploadUserProfilePicture() {
		post<Users.Id.UploadProfilePicture>(EUserScope.Admin) {
			val multipart = call.receiveMultipart()

			val image = multipart.readPart() as PartData.FileItem

			val user = userService.getUser(call.user, it.id.id) ?: run {
				call.respond(HttpStatusCode.NotFound, "User ${it.id.id} not found")
				return@post
			}

			val contentType = image.contentType ?: run {
				call.respond(HttpStatusCode.BadRequest, "Missing image content type")
				return@post
			}

			if (contentType != ContentType.Image.JPEG && contentType != ContentType.Image.PNG) {
				call.respond(HttpStatusCode.BadRequest, "Invalid image content type (only JPEG and PNG are supported)")
				return@post
			}

			userService.uploadUserProfilePicture(call.user, user, image.streamProvider().readBytes(), contentType.toString())

			call.respond(HttpStatusCode.OK)
		}
	}
}
