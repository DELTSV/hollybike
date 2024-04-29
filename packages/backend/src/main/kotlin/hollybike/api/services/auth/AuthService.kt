package hollybike.api.services.auth

import aws.smithy.kotlin.runtime.text.encoding.encodeBase64String
import com.auth0.jwt.JWT
import com.auth0.jwt.algorithms.Algorithm
import de.nycode.bcrypt.verify
import hollybike.api.ConfSecurity
import hollybike.api.exceptions.UserDisabled
import hollybike.api.exceptions.UserNotFoundException
import hollybike.api.exceptions.UserWrongPassword
import hollybike.api.repository.*
import hollybike.api.types.association.EAssociationsStatus
import hollybike.api.types.auth.TLogin
import hollybike.api.types.user.EUserScope
import hollybike.api.types.user.EUserStatus
import io.ktor.util.*
import org.jetbrains.exposed.dao.load
import org.jetbrains.exposed.sql.Database
import org.jetbrains.exposed.sql.transactions.transaction
import java.util.*
import javax.crypto.Mac
import javax.crypto.spec.SecretKeySpec

class AuthService (
	private val db: Database,
	private val conf: ConfSecurity,
	private val isOnPremise: Boolean
){
	private val key = SecretKeySpec(conf.secret.toByteArray(), "HmacSHA256")
	private val mac = Mac.getInstance("HmacSHA256").apply {
		init(key)
	}

	private fun generateJWT(email: String, scope: EUserScope) = JWT.create()
		.withAudience(conf.audience)
		.withIssuer(conf.domain)
		.withClaim("email", email)
		.withClaim("scope", scope.value)
		.withExpiresAt(Date(System.currentTimeMillis() + 60000 * 60 * 24))
		.sign(Algorithm.HMAC256(conf.secret))

	fun verifyLinkSignature(signature: String, host: String, role: EUserScope, association: Int? = null): Boolean =
		getLinkSignature(host, role, association) == signature

	private fun getLinkSignature(host: String, role: EUserScope, association: Int? = null): String {
		val value = association?.let { a ->
			"$host${role.value}$a"
		} ?: run {
			"$host${role.value}"
		}
		return mac.doFinal(value.toByteArray()).encodeBase64String()
	}

	fun generateLink(caller: User, host: String, role: EUserScope, association: Int? = null): String? {
		val sign = getLinkSignature(host, role, association)
		return if(isOnPremise) {
			"https://hollybike.fr/invite?host=$host&role=${role.value}&verify=$sign"
		} else if(caller.scope == EUserScope.Root && association != null){
			transaction(db) { Association.findById(association) } ?: return null
			return "https://hollybike.fr/invite?host=$host&role=${role.value}&association=${association}&verify=$sign"
		} else {
			return "https://hollybike.fr/invite?host=$host&role=${role.value}&association=${caller.association.id}&verify=$sign"
		}
	}

	fun login(login: TLogin): Result<String> {
		val user = transaction(db) { User.find { Users.email eq login.email }.singleOrNull()?.load(User::association) }
			?: return Result.failure(UserNotFoundException())
		if(!verify(login.password, user.password.decodeBase64Bytes())) {
			return Result.failure(UserWrongPassword())
		}
		if(user.status != EUserStatus.Enabled || user.association.status != EAssociationsStatus.Enabled) {
			return Result.failure(UserDisabled())
		}
		return Result.success(generateJWT(user.email, user.scope))
	}
}