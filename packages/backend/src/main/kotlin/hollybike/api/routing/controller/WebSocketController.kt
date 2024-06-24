package hollybike.api.routing.controller

import hollybike.api.repository.User
import hollybike.api.services.NotificationService
import hollybike.api.services.UserEventPositionService
import hollybike.api.types.websocket.*
import hollybike.api.utils.websocket.AuthVerifier
import hollybike.api.utils.websocket.WebSocketRouter
import hollybike.api.utils.websocket.webSocket
import io.ktor.server.application.*

class WebSocketController(
	application: Application,
	private val authVerifier: AuthVerifier,
	private val notificationService: NotificationService,
	private val userEventPositionService: UserEventPositionService
) {
	init {
		application.apply {
			webSocket("/api/connect") {
				this.authVerifier = this@WebSocketController.authVerifier
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
			onSubscribe {
				user = it
				for( notif in notificationService.getUserChannel(it.id.value)) {
					if(user == null){
						break
					}
					respond(notif.data)
				}
			}
			onUnsubscribe {
				user = null
			}
		}
	}

	private fun WebSocketRouter.userEventPosition() {
		var user: User? = null
		request("/event/{id}") {
			onSubscribe {
				user = it
				userEventPositionService.getSendChannel(parameters["id"]!!.toInt()).collect { position ->
					respond(position)
				}
			}
			onUnsubscribe {
				user = null
			}
			when(this.body) {
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