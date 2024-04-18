package hollybike.api.routing.controller

import com.auth0.jwt.JWT
import com.auth0.jwt.algorithms.Algorithm
import hollybike.api.conf
import hollybike.api.routing.resources.Login
import hollybike.api.routing.resources.Logout
import hollybike.api.routing.resources.Signin
import hollybike.api.types.auth.TAuthInfo
import hollybike.api.types.auth.TLogin
import hollybike.api.types.auth.TSignin
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.request.*
import io.ktor.server.resources.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import java.util.*
import io.ktor.server.resources.post

class AuthenticationController(
	val application: Application
) {

	init {
		application.routing {
			login()
			logout()
			signin()
		}
	}

	private fun generateJWT(email: String) = JWT.create()
		.withAudience(application.attributes.conf.security.audience)
		.withIssuer(application.attributes.conf.security.domain)
		.withClaim("email", email)
		.withExpiresAt(Date(System.currentTimeMillis() + 60000 * 60 * 24))
		.sign(Algorithm.HMAC256(application.attributes.conf.security.secret))

	private fun Route.login() {
		post<Login> {
			println("ICI 2")
			val login = call.receive<TLogin>()
			//TODO make work with the DB
			val token = generateJWT(login.email)
			// TODO store and retrieve token from db for auth
			call.respond(TAuthInfo(token))
		}
	}

	private fun Route.logout() {
		delete<Logout> {
			//TODO Delete token from DB
			call.respond(HttpStatusCode.NoContent)
		}
	}

	private fun Route.signin() {
		post<Signin> {
			val signin = call.receive<TSignin>()
			//TODO set data in db
			val token = generateJWT(signin.email)
			//TODO store token in db
			call.respond(TAuthInfo(token))
		}
	}
}