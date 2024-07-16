/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.utils.websocket

import com.auth0.jwt.JWT
import com.auth0.jwt.algorithms.Algorithm
import com.auth0.jwt.exceptions.JWTVerificationException
import hollybike.api.ConfSecurity
import hollybike.api.repository.User
import hollybike.api.repository.Users
import hollybike.api.types.user.EUserStatus
import io.ktor.util.logging.*
import org.jetbrains.exposed.dao.with
import org.jetbrains.exposed.sql.Database
import org.jetbrains.exposed.sql.and
import org.jetbrains.exposed.sql.transactions.transaction

class AuthVerifier(conf: ConfSecurity, private val db: Database, private val logger: Logger) {
	private val jwtSecret = conf.secret
	private val jwtAudience = conf.audience
	private val jwtDomain = conf.domain

	private val verifier = JWT
		.require(Algorithm.HMAC256(jwtSecret))
		.withAudience(jwtAudience)
		.withIssuer(jwtDomain)
		.build()

	fun verify(token: String): User? {
		return try {
			val decoded = verifier.verify(token)
			try {
				if (decoded.audience.contains(jwtAudience)) {
					val user = transaction(db) {
						User.find {
							(Users.email eq decoded.getClaim("email")
								.asString()) and (Users.status neq EUserStatus.Disabled.value)
						}.with(User::association).singleOrNull()
					} ?: run {
						return null
					}
					user
				} else {
					null
				}
			} catch (e: Exception) {
				e.printStackTrace()
				null
			}
		} catch (e: JWTVerificationException) {
			e.printStackTrace()
			println("Token error")
			null
		}
	}
}