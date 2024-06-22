package hollybike.api.routing.controller

import hollybike.api.repository.User
import hollybike.api.services.NotificationService
import hollybike.api.types.websocket.Subscribe
import hollybike.api.types.websocket.Subscribed
import hollybike.api.types.websocket.Unsubscribe
import hollybike.api.types.websocket.Unsubscribed
import hollybike.api.utils.websocket.AuthVerifier
import hollybike.api.utils.websocket.WebSocketRouter
import hollybike.api.utils.websocket.webSocket
import io.ktor.server.application.*
import org.jetbrains.exposed.sql.Database

class WebSocketController(
	application: Application,
	private val db: Database,
	private val authVerifier: AuthVerifier,
	private val notificationService: NotificationService
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
		var user: User?
		request("/notification") {
			when(this.body) {
				is Subscribe -> {
					user = authVerifier.verify(this.body.token)
					user?.let {
						respond(Subscribed(true))
						for( notif in notificationService.getUserChannel(it.id.value)) {
							if(user == null){
								break
							}
							respond(notif.data)
						}
					} ?: run {
						respond(Subscribed(false))
					}
				}
				is Unsubscribe -> {
					println("Unsub")
					respond(Unsubscribed(true))
					user = null
				}
				else -> {
					println("Unknown data")
				}
			}
		}
	}
}