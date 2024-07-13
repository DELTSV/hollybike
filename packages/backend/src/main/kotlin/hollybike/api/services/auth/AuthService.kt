package hollybike.api.services.auth

import com.auth0.jwt.JWT
import com.auth0.jwt.algorithms.Algorithm
import de.nycode.bcrypt.hash
import de.nycode.bcrypt.verify
import hollybike.api.ConfSecurity
import hollybike.api.exceptions.*
import hollybike.api.database.lower
import hollybike.api.repository.*
import hollybike.api.services.UserService
import hollybike.api.types.association.EAssociationsStatus
import hollybike.api.types.auth.*
import hollybike.api.types.user.EUserScope
import hollybike.api.types.user.EUserStatus
import hollybike.api.utils.MailSender
import hollybike.api.utils.isValidMail
import hollybike.api.utils.validPassword
import io.ktor.util.*
import kotlinx.datetime.*
import org.jetbrains.exposed.dao.load
import org.jetbrains.exposed.sql.Database
import org.jetbrains.exposed.sql.and
import org.jetbrains.exposed.sql.transactions.transaction
import java.util.*
import javax.crypto.Mac
import javax.crypto.spec.SecretKeySpec
import kotlin.concurrent.schedule
import kotlin.io.encoding.Base64
import kotlin.io.encoding.ExperimentalEncodingApi
import kotlin.time.Duration.Companion.days

class AuthService(
	private val db: Database,
	private val conf: ConfSecurity,
	private val invitationService: InvitationService,
	private val userService: UserService,
	private val mailSender: MailSender?
) {
	private val key = SecretKeySpec(conf.secret.toByteArray(), "HmacSHA256")
	private val mac = Mac.getInstance("HmacSHA256").apply {
		init(key)
	}

	private val timer = Timer()

	init {
		cleanToken()
		scheduleClean()
	}

	private fun scheduleClean() {
		timer.schedule(Date.from((Clock.System.now() + 30.days).toJavaInstant())) {
			cleanToken()
			scheduleClean()
		}
	}

	private fun cleanToken() {
		transaction(db) {
			Token.find { Tokens.lastUse less Clock.System.now() - 30.days }.forEach { it.delete() }
		}
	}

	@OptIn(ExperimentalEncodingApi::class)
	private val encoder = Base64.UrlSafe

	private fun generateJWT(email: String, scope: EUserScope) = JWT.create()
		.withAudience(conf.audience)
		.withIssuer(conf.domain)
		.withClaim("email", email)
		.withClaim("scope", scope.value)
		.withExpiresAt(Date(System.currentTimeMillis() + 60_000 * 60 * 24))
		.sign(Algorithm.HMAC256(conf.secret))

	private fun verifyLinkSignature(
		signature: String,
		host: String,
		role: EUserScope,
		association: Int,
		invitation: Int
	): Boolean = getLinkSignature(host, role, association, invitation) == signature

	@OptIn(ExperimentalEncodingApi::class)
	private fun getLinkSignature(host: String, role: EUserScope, association: Int, invitation: Int): String {
		val value = "$host$role$association$invitation"
		return encoder.encode(mac.doFinal(value.toByteArray()))
	}

	fun generateLink(host: String, invitation: Invitation): String {
		val sign = getLinkSignature(host, invitation.role, invitation.association.id.value, invitation.id.value)
		return "https://hollybike.fr/invite?host=$host&role=${invitation.role}&association=${invitation.association.id}&invitation=${invitation.id.value}&verify=$sign"
	}

	fun login(login: TLogin): Result<TAuthInfo> {
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
		val refresh = randomString(35)
		val device = login.device ?: UUID.randomUUID().toString()
		transaction(db) {
			Token.find { (Tokens.user eq user.id) and (Tokens.device eq device) }.firstOrNull()
				?.apply { token = refresh }
				?: Token.new {
					this.user = user
					this.device = device
					this.token = refresh
				}
		}
		return Result.success(
			TAuthInfo(
				generateJWT(user.email, user.scope),
				refresh,
				device
			)
		)
	}

	private val allowedChars = ('A'..'Z') + ('a'..'z') + ('0'..'9')

	private fun randomString(length: Int): String {
		return (1..length)
			.map { allowedChars.random() }
			.joinToString("")
	}

	fun signup(host: String, signup: TSignup): Result<TAuthInfo> {
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
		).map {
			val refresh = randomString(35)
			val deviceId = UUID.randomUUID().toString()
			transaction(db) {
				Token.new {
					user = it
					token = refresh
					device = deviceId
				}
			}
			TAuthInfo(
				generateJWT(it.email, it.scope),
				randomString(35),
				UUID.randomUUID().toString()
			)
		}.onFailure {
			return Result.failure(it)
		}
	}

	fun refreshAccessToken(refresh: TRefresh): TAuthInfo? {
		val newRefresh = randomString(35)
		return transaction(db) {
			Token.find { Tokens.device eq refresh.device }.firstOrNull()?.let {
				if (it.token == refresh.token) {
					it.token = newRefresh
					generateJWT(it.user.email, it.user.scope)
				} else {
					Token.find { Tokens.user eq it.user.id }.forEach { t -> t.delete() }
					null
				}
			}?.let {
				TAuthInfo(it, newRefresh, refresh.device)
			}
		}
	}

	@OptIn(ExperimentalEncodingApi::class)
	fun sendResetPassword(mail: String): Result<Unit> {
		val user = transaction(db) { User.find { Users.email eq mail }.firstOrNull() } ?: run {
			return Result.failure(UserNotFoundException())
		}
		val expire = Clock.System.now() + 1.days
		val token = encoder.encode(mac.doFinal("$mail-${expire.epochSeconds}".toByteArray(Charsets.UTF_8)))
		val link = "${conf.domain}/change-password?user=$mail&expire=${expire.epochSeconds}&token=$token"
		mailSender?.passwordMail(link, user.username, user.email) ?: run {
			return Result.failure(NoMailSenderException())
		}
		return Result.success(Unit)
	}

	@OptIn(ExperimentalEncodingApi::class)
	fun resetPassword(mail: String, password: TResetPassword): Result<Unit> {
		password.newPassword.validPassword().onFailure {
			return Result.failure(it)
		}
		val user = transaction(db) { User.find { Users.email eq mail }.firstOrNull() } ?: run {
			return Result.failure(UserNotFoundException())
		}
		val verify = encoder.encode(mac.doFinal("$mail-${password.expire}".toByteArray(Charsets.UTF_8)))
		if(password.token != verify) {
			return Result.failure(NotAllowedException())
		}
		if(password.newPassword != password.newPasswordConfirmation) {
			return Result.failure(UserDifferentNewPassword())
		}
		if(Instant.fromEpochSeconds(password.expire) < Clock.System.now()) {
			return Result.failure(LinkExpire())
		}
		transaction(db) { user.password = hash(password.newPassword).encodeBase64() }
		return Result.success(Unit)
	}
}