package hollybike.api.services.storage.signature

import com.auth0.jwt.JWT
import com.auth0.jwt.algorithms.Algorithm
import hollybike.api.ConfSecurity
import java.util.*

class LocalStorageSignatureService(
	private val conf: ConfSecurity,
): StorageSignatureService {
	private fun generateJWT(objectPath: String) = JWT.create()
		.withAudience(conf.audience)
		.withIssuer(conf.domain)
		.withClaim("objectPath", objectPath)
		.withExpiresAt(Date(System.currentTimeMillis() + 60000 * 60))
		.sign(Algorithm.HMAC256(conf.secret + "image-signer"))

	private fun getSignedPath(path: String): String =
		"${conf.domain}/storage/object?signature=${generateJWT(path)}"

	override val signer = { path: String -> getSignedPath(path) }
}