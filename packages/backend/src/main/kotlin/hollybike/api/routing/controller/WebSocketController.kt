package hollybike.api.routing.controller

import hollybike.api.repository.User
import hollybike.api.services.NotificationService
import hollybike.api.services.UserEventPositionService
import hollybike.api.types.websocket.*
import hollybike.api.utils.websocket.AuthVerifier
import hollybike.api.utils.websocket.WebSocketRouter
import hollybike.api.utils.websocket.webSocket
import io.ktor.server.application.*
import org.jetbrains.exposed.sql.Database

class WebSocketController(
	application: Application,
	private val db: Database,
	private val authVerifier: AuthVerifier,
	private val notificationService: NotificationService,
	private val userEventPositionService: UserEventPositionService
) {
	init {
		application.apply {
			webSocket("/api/connect", db) {
				routing {
					notification()
					userEventPosition()
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

	private fun WebSocketRouter.userEventPosition() {
		var user: User? = null
		request("/event/{id}") {
			when(this.body) {
				is Subscribe -> {
					user = authVerifier.verify(this.body.token)
					user?.let {
						respond(Subscribed(true))
						for(position in userEventPositionService.getSendChannel(parameters["id"]!!.toInt())) {
							respond(position)
						}
					} ?: run {
						respond(Unsubscribed(false))
					}
				}
				is Unsubscribe -> {
					respond(Unsubscribed(true))
					user = null
				}
				is UserSendPosition -> {
					user?.let {
						userEventPositionService.getReceiveChannel(parameters["id"]!!.toInt(), it.id.value).send(this.body)
					}
				}
				else -> {}
			}
		}
	}
}