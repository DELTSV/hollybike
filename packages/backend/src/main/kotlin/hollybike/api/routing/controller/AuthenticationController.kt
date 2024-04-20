package hollybike.api.routing.controller

import com.auth0.jwt.JWT
import com.auth0.jwt.algorithms.Algorithm
import de.nycode.bcrypt.hash
import de.nycode.bcrypt.verify
import hollybike.api.conf
import hollybike.api.isOnPremise
import hollybike.api.repository.User
import hollybike.api.repository.users
import hollybike.api.repository.associations
import hollybike.api.routing.resources.Login
import hollybike.api.routing.resources.Logout
import hollybike.api.routing.resources.Signin
import hollybike.api.types.auth.TAuthInfo
import hollybike.api.types.auth.TLogin
import hollybike.api.types.auth.TSignin
import hollybike.api.utils.isValidMail
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.request.*
import io.ktor.server.resources.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import java.util.*
import io.ktor.server.resources.post
import io.ktor.util.*
import kotlinx.datetime.Clock
import org.ktorm.database.Database
import org.ktorm.dsl.eq
import org.ktorm.entity.add
import org.ktorm.entity.find
import org.ktorm.entity.first
import org.postgresql.util.PSQLException

class AuthenticationController(
	private val application: Application,
	private val db: Database
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
			val login = call.receive<TLogin>()
			db.users.find { (it.email eq login.email) }?.let {
				if(verify(login.password, it.password.decodeBase64Bytes())) {
					it.lastLogin = Clock.System.now()
					it.flushChanges()
					val token = generateJWT(login.email)
					call.respond(TAuthInfo(token))
				} else {
					call.respond(HttpStatusCode.Unauthorized)
				}
			} ?: run {
				call.respond(HttpStatusCode.NotFound)
			}
		}
	}

	private fun Route.logout() {
		delete<Logout> {
			call.respond(HttpStatusCode.NoContent)
		}
	}

	private fun Route.signin() {
		post<Signin> {
			val signin = call.receive<TSignin>()
			if(!signin.email.isValidMail()) {
				call.respond(HttpStatusCode.BadRequest, "Invalid email")
				return@post
			}
			val association = if(application.isOnPremise) {
				db.associations.first()
			} else if(signin.association == null) {
				call.respond(HttpStatusCode.BadRequest, "Associations needed")
				return@post
			} else {
				db.associations.find { it.id eq signin.association } ?: run {
					call.respond(HttpStatusCode.NotFound, "Association ${signin.association} not found")
					return@post
				}
			}
			try {
				db.users.add(User {
					email = signin.email
					username = signin.username
					password = hash(signin.password, 4).encodeBase64()
					this.association = association
					lastLogin = Clock.System.now()
				})
				val token = generateJWT(signin.email)
				call.respond(TAuthInfo(token))
			}catch (e: PSQLException) {
				if(e.serverErrorMessage?.constraint == "users_email_uindex" && e.serverErrorMessage?.detail?.contains("already exists") == true) {
					call.respond(HttpStatusCode.Conflict, "Email already exist")
				} else {
					call.respond(HttpStatusCode.InternalServerError, "Internal server error")
				}
			}
		}
	}
}