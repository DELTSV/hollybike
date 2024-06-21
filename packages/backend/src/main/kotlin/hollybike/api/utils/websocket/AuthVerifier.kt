package hollybike.api.utils.websocket

import com.auth0.jwt.JWT
import com.auth0.jwt.algorithms.Algorithm
import com.auth0.jwt.exceptions.JWTVerificationException
import hollybike.api.ConfSecurity
import hollybike.api.repository.User
import hollybike.api.repository.Users
import hollybike.api.types.user.EUserStatus
import hollybike.api.types.websocket.Message
import hollybike.api.types.websocket.Subscribe
import io.ktor.util.*
import io.ktor.util.logging.*
import io.ktor.websocket.*
import kotlinx.serialization.json.Json
import org.jetbrains.exposed.dao.with
import org.jetbrains.exposed.sql.Database
import org.jetbrains.exposed.sql.and
import org.jetbrains.exposed.sql.transactions.transaction

class AuthVerifierExtension(conf: ConfSecurity, private val db: Database, val logger: Logger): WebSocketExtension<AuthVerifierExtension.Config> {
	class Config {
		lateinit var logger: Logger
		lateinit var db: Database
		lateinit var conf: ConfSecurity
	}

	override val protocols: List<WebSocketExtensionHeader> = emptyList()

	override fun serverNegotiation(requestedProtocols: List<WebSocketExtensionHeader>): List<WebSocketExtensionHeader> {
		return emptyList()
	}

	override fun clientNegotiation(negotiatedProtocols: List<WebSocketExtensionHeader>): Boolean {
		return true
	}

	override fun processIncomingFrame(frame: Frame): Frame {
		val text = frame.readBytes().toString(Charsets.UTF_8)
		val message = Json.decodeFromString<Message>(text)
		if(message.data is Subscribe) {
			message.data.user = verify(message.data.token)?.id?.value
		}
		return Frame.Text(text)
	}

	override fun processOutgoingFrame(frame: Frame): Frame = frame

	override val factory: WebSocketExtensionFactory<Config, AuthVerifierExtension> = AuthVerifierExtension

	companion object: WebSocketExtensionFactory<Config, AuthVerifierExtension> {
		override val key: AttributeKey<AuthVerifierExtension>
			get() {
				println("Getting")
				return AttributeKey("AuthVerifierExtension")
			}

		override val rsv1: Boolean = false
		override val rsv2: Boolean = false
		override val rsv3: Boolean = false

		override fun install(config: Config.() -> Unit): AuthVerifierExtension {
			println("Installing me")
			val conf = Config().apply(config)
			return AuthVerifierExtension(conf.conf, conf.db, conf.logger)
		}

	}

	private val jwtSecret = conf.secret
	private val jwtAudience = conf.audience
	private val jwtDomain = conf.domain

	private val verifier = JWT
		.require(Algorithm.HMAC256(jwtSecret))
		.withAudience(jwtAudience)
		.withIssuer(jwtDomain)
		.build()

	private fun verify(token: String): User? {
		println("COUCOU")
		return try {
			val decoded = verifier.verify(token)
			try {
				println(decoded.audience)
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
			println("Token error")
			null
		}
	}
}