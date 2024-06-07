package hollybike.api.routing.controller

import hollybike.api.conf
import hollybike.api.exceptions.*
import hollybike.api.routing.resources.Auth
import hollybike.api.services.auth.AuthService
import hollybike.api.types.auth.TAuthInfo
import hollybike.api.types.auth.TLogin
import hollybike.api.types.auth.TSignup
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.request.*
import io.ktor.server.resources.post
import io.ktor.server.response.*
import io.ktor.server.routing.*

class AuthenticationController(
	application: Application,
	private val authService: AuthService
) {
	init {
		application.routing {
			login()
			signup()
		}
	}

	private fun Route.login() {
		post<Auth.Login> {
			val login = call.receive<TLogin>()
			authService.login(login).onSuccess {
				call.respond(TAuthInfo(it))
			}.onFailure {
				when(it) {
					is UserNotFoundException -> call.respond(HttpStatusCode.NotFound, "Utilisateur inconnu")
					is UserWrongPassword -> call.respond(HttpStatusCode.Unauthorized, "Mauvais mot de passe")
					is UserDisabled -> call.respond(HttpStatusCode.Forbidden)
				}
			}
		}
	}

	private fun Route.signup() {
		post<Auth.Signup> {
			val signup = call.receive<TSignup>()
			val host = call.application.attributes.conf.security.domain
			authService.signup(host, signup).onSuccess {
				call.respond(TAuthInfo(it))
			}.onFailure {
				when(it) {
					is InvalidMailException -> call.respond(HttpStatusCode.BadRequest, "Email invalide")
					is NotAllowedException -> call.respond(HttpStatusCode.Forbidden)
					is InvitationNotFoundException -> call.respond(HttpStatusCode.NotFound, "Aucune invitation valide")
					is UserAlreadyExists -> call.respond(HttpStatusCode.Conflict, "L'utilisateur existe déjà")
					else -> {
						it.printStackTrace()
						call.respond(HttpStatusCode.InternalServerError)
					}
				}
			}
		}
	}
}
