package hollybike.api.routing.controller

import hollybike.api.exceptions.*
import hollybike.api.plugins.user
import hollybike.api.repository.associationMapper
import hollybike.api.repository.userMapper
import hollybike.api.routing.resources.Users
import hollybike.api.services.UserService
import hollybike.api.types.association.TAssociation
import hollybike.api.types.lists.TLists
import hollybike.api.types.user.EUserScope
import hollybike.api.types.user.TUser
import hollybike.api.types.user.TUserUpdate
import hollybike.api.types.user.TUserUpdateSelf
import hollybike.api.utils.get
import hollybike.api.utils.patch
import hollybike.api.utils.post
import hollybike.api.utils.search.getMapperData
import hollybike.api.utils.search.getSearchParam
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
import kotlin.math.ceil

class UserController(
	application: Application,
	private val userService: UserService,
	private val host: String
) {
	init {
		application.routing {
			authenticate {
				getUserAssociation()
				getMe()
				getUserById()
				getByUserName()
				getByEmail()
				update()
				updateMe()
				uploadMeProfilePicture()
				uploadUserProfilePicture()
				getAll()
				getMetadata()
			}
		}
	}

	private fun Route.getUserAssociation() {
		get<Users.Id.Association>(EUserScope.Root) { params ->
			userService.getUserAssociation(call.user, params.id.id)?.let {
				call.respond(TAssociation(it))
			} ?: run {
				call.respond(HttpStatusCode.NotFound, "Utilisateur inconnu")
			}
		}
	}

	private fun Route.getMe() {
		get<Users.Me> {
			call.respond(TUser(call.user, host))
		}
	}

	private fun Route.getUserById() {
		get<Users.Id>(EUserScope.Admin) {
			userService.getUser(call.user, it.id)?.let { user ->
				call.respond(TUser(user, host))
			} ?: run {
				call.respond(HttpStatusCode.NotFound, "Utilisateur inconnu")
			}
		}
	}

	private fun Route.getByUserName() {
		get<Users.Username>(EUserScope.Admin) {
			userService.getUserByUsername(call.user, it.username)?.let { user ->
				call.respond(TUser(user, host))
			} ?: run {
				call.respond(HttpStatusCode.NotFound, "Utilisateur inconnu")
			}
		}
	}

	private fun Route.getByEmail() {
		get<Users.Email>(EUserScope.Admin) {
			userService.getUserByEmail(call.user, it.email)?.let { user ->
				call.respond(TUser(user, host))
			} ?: run {
				call.respond(HttpStatusCode.NotFound, "Utilisateur inconnu")
			}
		}
	}

	private fun Route.update() {
		this.patch<Users.Id>(EUserScope.Admin) {
			val update = call.receive<TUserUpdate>()
			val user = userService.getUser(call.user, it.id) ?: run {
				call.respond(HttpStatusCode.NotFound, "Utilisateur inconnu")
				return@patch
			}
			userService.updateUser(call.user, user, update).onSuccess { u ->
				call.respond(TUser(u))
			}.onFailure { e ->
				when (e) {
					is NotAllowedException -> call.respond(HttpStatusCode.Forbidden)
					is UserNotFoundException -> call.respond(HttpStatusCode.NotFound, "Utilisateur inconnu")
				}
			}
		}
	}

	private fun Route.updateMe() {
		this.patch<Users.Me> {
			val update = call.receive<TUserUpdateSelf>()
			userService.updateMe(call.user, update).onSuccess {
				call.respond(TUser(it, host))
			}.onFailure {
				when (it) {
					is BadRequestException -> call.respond(
						HttpStatusCode.BadRequest,
						"Changer de mot de passe nécessite new_password, new_password_again et old_password"
					)

					is UserWrongPassword -> call.respond(HttpStatusCode.Unauthorized, "Mauvais old_password")
					is UserDifferentNewPassword -> call.respond(
						HttpStatusCode.BadRequest,
						"new_password et _new_password_again sont différent"
					)
				}
			}
		}
	}

	private fun Route.uploadMeProfilePicture() {
		post<Users.Me.UploadProfilePicture> {
			val multipart = call.receiveMultipart()

			val image = multipart.readPart() as PartData.FileItem

			val contentType = image.contentType ?: run {
				call.respond(HttpStatusCode.BadRequest, "Type de contenu de l'image manquant")
				return@post
			}

			if (contentType != ContentType.Image.JPEG && contentType != ContentType.Image.PNG) {
				call.respond(HttpStatusCode.BadRequest, "Image invalide (JPEG et PNG seulement)")
				return@post
			}

			userService.uploadUserProfilePicture(
				call.user,
				call.user,
				image.streamProvider().readBytes(),
				contentType.toString()
			)

			call.respond(HttpStatusCode.OK)
		}
	}

	private fun Route.uploadUserProfilePicture() {
		post<Users.Id.UploadProfilePicture>(EUserScope.Admin) {
			val multipart = call.receiveMultipart()

			val image = multipart.readPart() as PartData.FileItem

			val user = userService.getUser(call.user, it.id.id) ?: run {
				call.respond(HttpStatusCode.NotFound, "Utilisateur ${it.id.id} inconnu")
				return@post
			}

			val contentType = image.contentType ?: run {
				call.respond(HttpStatusCode.BadRequest, "Type de contenu de l'image manquant")
				return@post
			}

			if (contentType != ContentType.Image.JPEG && contentType != ContentType.Image.PNG) {
				call.respond(HttpStatusCode.BadRequest, "Image invalide (JPEG et PNG seulement)")
				return@post
			}

			userService.uploadUserProfilePicture(
				call.user,
				user,
				image.streamProvider().readBytes(),
				contentType.toString()
			)

			call.respond(HttpStatusCode.OK)
		}
	}

	private fun Route.getAll() {
		get<Users>(EUserScope.Admin) {
			val param = call.request.queryParameters.getSearchParam(userMapper + associationMapper)
			val list = userService.getAll(call.user, param)?.map { TUser(it, host) }
			val count = userService.getAllCount(call.user, param)
			if (list != null && count != null) {
				call.respond(
					TLists(
						list,
						param.page,
						ceil(count.toDouble() / param.perPage).toInt(),
						param.perPage,
						count.toInt()
					)
				)
			} else {
				call.respond(HttpStatusCode.Forbidden)
			}
		}
	}

	private fun Route.getMetadata() {
		get<Users.MetaData>(EUserScope.Admin) {
			call.respond((userMapper + associationMapper).getMapperData())
		}
	}
}
