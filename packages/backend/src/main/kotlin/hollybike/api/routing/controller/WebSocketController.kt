package hollybike.api.routing.controller

import hollybike.api.repository.User
import hollybike.api.types.websocket.Subscribe
import hollybike.api.types.websocket.Subscribed
import hollybike.api.utils.websocket.AuthVerifier
import hollybike.api.utils.websocket.WebSocketRouter
import hollybike.api.utils.websocket.webSocket
import io.ktor.server.application.*
import org.jetbrains.exposed.sql.Database

class WebSocketController(
	application: Application,
	private val db: Database,
	private val authVerifier: AuthVerifier
) {
	init {
		application.apply {
			webSocket("/api/connect", db) {
				routing {
					notification()
				}
			}
		}
	}

	private fun WebSocketRouter.notification() {
		request("/notification") {
			var user: User? = null
			when(this.body) {
				is Subscribe -> {
					user = authVerifier.verify(this.body.token)
					user?.let {
						respond(Subscribed(true))
					} ?: run {
						respond(Subscribed(false))
					}
				}
				else -> {
					println("Unknown data")
				}
			}
		}
	}
}