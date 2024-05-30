package hollybike.api.services.auth

import aws.smithy.kotlin.runtime.text.encoding.encodeBase64String
import com.auth0.jwt.JWT
import com.auth0.jwt.algorithms.Algorithm
import de.nycode.bcrypt.verify
import hollybike.api.ConfSecurity
import hollybike.api.exceptions.*
import hollybike.api.repository.Invitation
import hollybike.api.repository.User
import hollybike.api.repository.Users
import hollybike.api.database.lower
import hollybike.api.services.UserService
import hollybike.api.types.association.EAssociationsStatus
import hollybike.api.types.auth.TLogin
import hollybike.api.types.auth.TSignup
import hollybike.api.types.user.EUserScope
import hollybike.api.types.user.EUserStatus
import hollybike.api.utils.isValidMail
import io.ktor.util.*
import org.jetbrains.exposed.dao.load
import org.jetbrains.exposed.sql.Database
import org.jetbrains.exposed.sql.transactions.transaction
import java.util.*
import javax.crypto.Mac
import javax.crypto.spec.SecretKeySpec

class AuthService(
	private val db: Database,
	private val conf: ConfSecurity,
	private val invitationService: InvitationService,
	private val userService: UserService
) {
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

	private fun verifyLinkSignature(
		signature: String,
		host: String,
		role: EUserScope,
		association: Int,
		invitation: Int
	): Boolean =
		getLinkSignature(host, role, association, invitation) == signature

	private fun getLinkSignature(host: String, role: EUserScope, association: Int, invitation: Int): String {
		val value = "$host${role.value}$association$invitation"
		return mac.doFinal(value.toByteArray()).encodeBase64String()
	}

	fun generateLink(caller: User, host: String, invitation: Invitation): String {
		val sign = getLinkSignature(host, invitation.role, invitation.association.id.value, invitation.id.value)
		return "https://hollybike.fr/invite?host=$host&role=${invitation.role.value}&association=${caller.association.id}&invitation=${invitation.id.value}&verify=$sign"
	}

	fun login(login: TLogin): Result<String> {
		val user = transaction(db) {
			User.find { lower(Users.email) eq lower(login.email) }.singleOrNull()?.load(User::association)
		}
			?: return Result.failure(UserNotFoundException())
		if (!verify(login.password, user.password.decodeBase64Bytes())) {
			return Result.failure(UserWrongPassword())
		}
		if (user.status != EUserStatus.Enabled || user.association.status != EAssociationsStatus.Enabled) {
			return Result.failure(UserDisabled())
		}
		return Result.success(generateJWT(user.email, user.scope))
	}

	fun signup(host: String, signup: TSignup): Result<String> {
		if (!signup.email.isValidMail()) {
			return Result.failure(InvalidMailException())
		}
		if (!verifyLinkSignature(signup.verify, host, signup.role, signup.association, signup.invitation)) {
			return Result.failure(NotAllowedException())
		}
		transaction(db) {
			invitationService.getValidInvitation(signup.invitation)?.let {
				it.uses += 1
			}
		} ?: run {
			return Result.failure(InvitationNotFoundException())
		}

		return userService.createUser(
			signup.email,
			signup.password,
			signup.username,
			signup.association,
			signup.role
		).map { generateJWT(it.email, it.scope) }.onFailure {
			return Result.failure(it)
		}
	}
}