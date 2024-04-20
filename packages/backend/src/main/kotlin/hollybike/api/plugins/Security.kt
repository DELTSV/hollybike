package hollybike.api.plugins

import com.auth0.jwt.JWT
import com.auth0.jwt.algorithms.Algorithm
import hollybike.api.conf
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.auth.jwt.*

fun Application.configureSecurity() {
	println("Configuring security")
	val jwtAudience = attributes.conf.security.audience
	val jwtDomain = attributes.conf.security.domain
	val jwtRealm = attributes.conf.security.realm
	val jwtSecret = attributes.conf.security.secret
	authentication {
		jwt {
			realm = jwtRealm
			verifier(
				JWT
					.require(Algorithm.HMAC256(jwtSecret))
					.withAudience(jwtAudience)
					.withIssuer(jwtDomain)
					.build(),
			)
			validate { credential ->
				if (credential.payload.audience.contains(jwtAudience)) JWTPrincipal(credential.payload) else null
			}
		}
	}
}
