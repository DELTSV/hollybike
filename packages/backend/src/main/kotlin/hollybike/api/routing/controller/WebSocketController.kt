package hollybike.api.routing.controller

import hollybike.api.repository.User
import hollybike.api.services.NotificationService
import hollybike.api.services.UserEventPositionService
import hollybike.api.types.websocket.*
import hollybike.api.utils.websocket.AuthVerifier
import hollybike.api.utils.websocket.WebSocketRouter
import hollybike.api.utils.websocket.on
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
				this.logger = application.log
				routing {
					notification()
					userEventPosition()
				}
			}
		}
	}

	private fun WebSocketRouter.notification() {
		var user: User? = null
		request("/notification") {
			onSubscribe {
				user = it
				notificationService.getUserChannel(it.id.value).collect { notif ->
					if(user == null) {
						return@collect
					}
					respond(notif.data)
				}
			}
			onUnsubscribe {
				user = null
			}
			on<ReadNotification> {
				user?.let { u ->
					val notification = notificationService.getNotificationById(u, it.notification) ?: run {
						return@on
					}
					notificationService.setNotificationSeen(notification, true)
				}
			}
		}
	}

	private fun WebSocketRouter.userEventPosition() {
		var user: User? = null
		request("/event/{id}") {
			onSubscribe {
				user = it
				userEventPositionService.lastPosition[parameters["id"]!!.toInt()]?.forEach { entry ->
					respond(UserReceivePosition(entry.value))
				}
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
				is StopUserSendPosition -> {
					user?.let {
						userEventPositionService.getReceiveChannel(parameters["id"]!!.toInt(), it.id.value).send(this.body)
					}
				}
				else -> {}
			}
		}
	}
}