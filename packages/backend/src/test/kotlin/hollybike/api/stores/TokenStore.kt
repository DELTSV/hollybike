/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.stores

import com.auth0.jwt.JWT
import com.auth0.jwt.algorithms.Algorithm
import hollybike.api.types.user.EUserScope
import java.util.*

class TokenStore {
	private val tokens = mutableMapOf<String, String>()
	private val users = mutableMapOf(
		"root@hollybike.fr" to EUserScope.Root,
		"user1@hollybike.fr" to EUserScope.User,
		"user2@hollybike.fr" to EUserScope.User,
		"user3@hollybike.fr" to EUserScope.User,
		"user4@hollybike.fr" to EUserScope.User,
		"admin1@hollybike.fr" to EUserScope.Admin,
		"admin2@hollybike.fr" to EUserScope.Admin,
	)

	private fun generateJWT(email: String, scope: EUserScope) =
		JWT.create()
			.withAudience("audience")
			.withIssuer("domain")
			.withClaim("email", email)
			.withClaim("scope", scope.value)
			.withExpiresAt(
				Date(System.currentTimeMillis() + 60000 * 60 * 24)
			)
			.sign(Algorithm.HMAC256("secret"))

	init {
		users.forEach { (email, scope) ->
			tokens[email] = generateJWT(email, scope)
		}
	}

	fun get(email: String): String = tokens[email] ?: error("Token not found")

	operator fun get(user: Pair<Int, String>): String = tokens[user.second] ?: error("Token not found")
}