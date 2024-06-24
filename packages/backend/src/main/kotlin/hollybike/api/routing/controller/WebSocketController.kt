package hollybike.api.routing.controller

import hollybike.api.services.NotificationService
import hollybike.api.services.UserEventPositionService
import hollybike.api.types.websocket.*
import hollybike.api.utils.websocket.AuthVerifier
import hollybike.api.utils.websocket.WebSocketRouter
import hollybike.api.utils.websocket.webSocket
import io.ktor.server.application.*
import kotlinx.coroutines.flow.onEach

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
		request("/notification") {
			onSubscribe {
				user?.let {
					for( notif in notificationService.getUserChannel(it.id.value)) {
						if(user == null){
							break
						}
						respond(notif.data)
					}
				}
			}
			onUnsubscribe()
		}
	}

	private fun WebSocketRouter.userEventPosition() {
		request("/event/{id}") {
			onSubscribe {
				user?.let {
					respond(Subscribed(true))
					userEventPositionService.getSendChannel(parameters["id"]!!.toInt()).onEach {
						respond(it)
					}
				}
			}
			onUnsubscribe()
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