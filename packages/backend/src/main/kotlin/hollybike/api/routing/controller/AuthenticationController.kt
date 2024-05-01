package hollybike.api.routing.controller

import com.auth0.jwt.JWT
import com.auth0.jwt.algorithms.Algorithm
import hollybike.api.conf
import hollybike.api.exceptions.*
import hollybike.api.routing.resources.Auth
import hollybike.api.services.auth.AuthService
import hollybike.api.types.auth.TAuthInfo
import hollybike.api.types.auth.TLogin
import hollybike.api.types.auth.TSignin
import hollybike.api.types.user.EUserScope
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.request.*
import io.ktor.server.resources.post
import io.ktor.server.response.*
import io.ktor.server.routing.*
import org.jetbrains.exposed.sql.Database
import java.util.*
import javax.crypto.Mac
import javax.crypto.spec.SecretKeySpec

class AuthenticationController(
	private val application: Application,
	private val db: Database,
	private val authService: AuthService
) {
	private val key = SecretKeySpec(application.attributes.conf.security.secret.toByteArray(), "HmacSHA256")
	private val mac = Mac.getInstance("HmacSHA256").apply {
		init(key)
	}

	init {
		application.routing {
			login()
			signin()
		}
	}

	private fun generateJWT(email: String, scope: EUserScope) = JWT.create()
		.withAudience(application.attributes.conf.security.audience)
		.withIssuer(application.attributes.conf.security.domain)
		.withClaim("email", email)
		.withClaim("scope", scope.value)
		.withExpiresAt(Date(System.currentTimeMillis() + 60000 * 60 * 24))
		.sign(Algorithm.HMAC256(application.attributes.conf.security.secret))

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

	private fun Route.signin() {
		post<Auth.Signin> {
			val signin = call.receive<TSignin>()
			val host = call.request.headers["Host"] ?: run {
				call.respond(HttpStatusCode.BadRequest, "Aucun Host")
				return@post
			}
			authService.signin(host, signin).onSuccess {
				call.respond(TAuthInfo(it))
			}.onFailure {
				when(it) {
					is InvalidMailException -> call.respond(HttpStatusCode.BadRequest, "Email invalide")
					is NotAllowedException -> call.respond(HttpStatusCode.Forbidden)
					is InvitationNotFoundException -> call.respond(HttpStatusCode.NotFound, "Aucune invitation valide")
					is AssociationNotFound -> call.respond(HttpStatusCode.NotFound, "Association inconnue")
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
