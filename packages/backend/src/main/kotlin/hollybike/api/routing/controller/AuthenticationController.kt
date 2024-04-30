package hollybike.api.routing.controller

import aws.smithy.kotlin.runtime.text.encoding.encodeBase64String
import com.auth0.jwt.JWT
import com.auth0.jwt.algorithms.Algorithm
import de.nycode.bcrypt.hash
import hollybike.api.conf
import hollybike.api.exceptions.UserDisabled
import hollybike.api.exceptions.UserNotFoundException
import hollybike.api.exceptions.UserWrongPassword
import hollybike.api.isOnPremise
import hollybike.api.repository.Association
import hollybike.api.repository.Associations
import hollybike.api.repository.User
import hollybike.api.routing.resources.Auth
import hollybike.api.services.auth.AuthService
import hollybike.api.types.auth.TAuthInfo
import hollybike.api.types.auth.TLogin
import hollybike.api.types.auth.TSignin
import hollybike.api.types.user.EUserScope
import hollybike.api.types.user.EUserStatus
import hollybike.api.utils.isValidMail
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.request.*
import io.ktor.server.resources.post
import io.ktor.server.response.*
import io.ktor.server.routing.*
import io.ktor.util.*
import kotlinx.datetime.Clock
import org.jetbrains.exposed.exceptions.ExposedSQLException
import org.jetbrains.exposed.sql.Database
import org.jetbrains.exposed.sql.transactions.transaction
import org.postgresql.util.PSQLException
import java.sql.BatchUpdateException
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
					is UserNotFoundException -> call.respond(HttpStatusCode.NotFound, "User not found")
					is UserWrongPassword -> call.respond(HttpStatusCode.Unauthorized, "Wrong password")
					is UserDisabled -> call.respond(HttpStatusCode.Forbidden)
				}
			}
		}
	}

	private fun Route.signin() {
		post<Auth.Signin> {
			val signin = call.receive<TSignin>()
			if (!signin.email.isValidMail()) {
				call.respond(HttpStatusCode.BadRequest, "Invalid email")
				return@post
			}
			val role = try {
				EUserScope[signin.role]
			} catch (_: NoSuchElementException) {
				call.respond(HttpStatusCode.BadRequest, "Role not found")
				return@post
			}
			val association =
				if (application.isOnPremise) {
					transaction(db) { Association[1] }
				} else if (signin.association == null) {
					call.respond(HttpStatusCode.BadRequest, "Associations needed")
					return@post
				} else {
					transaction(db) { Association.find { Associations.id eq signin.association }.singleOrNull() }
						?: run {
							call.respond(HttpStatusCode.NotFound, "Association ${signin.association} not found")
							return@post
						}
				}
			val host = call.request.headers["Host"] ?: run {
				call.respond(HttpStatusCode.BadRequest, "No Host")
				return@post
			}
			val checksum = signin.association?.let {
				mac.doFinal("$host${role.value}$it".encodeToByteArray()).encodeBase64String()
			} ?: run {
				mac.doFinal("$host${role.value}".encodeToByteArray()).encodeBase64String()
			}
			if(checksum != signin.verify) {
				println(checksum)
				println(signin.verify)
				call.respond(HttpStatusCode.Forbidden)
				return@post
			}
			try {
				val user = transaction(db) {
					User.new {
						email = signin.email
						username = signin.username
						password = hash(signin.password, 4).encodeBase64()
						status = EUserStatus.Enabled
						scope = role
						this.association = association
						lastLogin = Clock.System.now()
					}
				}
				val token = generateJWT(signin.email, user.scope)
				call.respond(TAuthInfo(token))
			} catch (e: ExposedSQLException) {
				if(e.cause is BatchUpdateException && (e.cause as BatchUpdateException).cause is PSQLException) {
					val cause = (e.cause as BatchUpdateException).cause as PSQLException
					if (
						cause.serverErrorMessage?.constraint == "users_email_uindex" &&
						cause.serverErrorMessage?.detail?.contains("already exists") == true
					) {
						call.respond(HttpStatusCode.Conflict, "Email already exist")
						return@post
					}
				}
				e.printStackTrace()
				call.respond(HttpStatusCode.InternalServerError, "Internal server error")
			}
		}
	}
}
