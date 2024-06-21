package hollybike.api.routing.controller

import hollybike.api.repository.User
import hollybike.api.types.websocket.Subscribe
import hollybike.api.utils.websocket.WebSocketRouter
import hollybike.api.utils.websocket.webSocket
import io.ktor.server.application.*
import org.jetbrains.exposed.sql.Database
import org.jetbrains.exposed.sql.transactions.transaction

class WebSocketController(
	application: Application,
	private val db: Database
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
					body.user?.let {
						user = transaction(db) { User.findById(it) }
						println("SUBSCRIBED")
					} ?: run {
						println("SALE MERDE")
					}
				}
				else -> {
					println("Unknown data")
				}
			}
		}
	}
}