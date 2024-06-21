package hollybike.api.routing.controller

import hollybike.api.plugins.user
import hollybike.api.repository.notificationMapper
import hollybike.api.repository.userMapper
import hollybike.api.routing.resources.Notifications
import hollybike.api.services.NotificationService
import hollybike.api.types.lists.TLists
import hollybike.api.types.user.EUserScope
import hollybike.api.types.websocket.TNotification
import hollybike.api.utils.search.getMapperData
import hollybike.api.utils.search.getSearchParam
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.resources.*
import io.ktor.server.response.*
import io.ktor.server.routing.Route
import io.ktor.server.routing.routing
import kotlin.math.ceil

class NotificationController(
	application: Application,
	private val notificationService: NotificationService
) {
	init {
		application.routing {
			getAll()
			getMetaData()
			seenAll()
			seenNotification()
		}
	}

	private fun Route.getAll() {
		get<Notifications> {
			val mapper = if (call.user.scope == EUserScope.Root) {
				notificationMapper + userMapper
			} else {
				notificationMapper
			}
			val searchParam = call.request.queryParameters.getSearchParam(mapper)
			val list = notificationService.getAll(call.user, searchParam)
			val count = notificationService.getAllCount(call.user, searchParam)
			call.respond(
				TLists(
					list.map { TNotification(it) },
					searchParam.page,
					ceil(count.toDouble() / searchParam.perPage).toInt(),
					searchParam.perPage,
					count.toInt()
				)
			)
		}
	}

	private fun Route.getMetaData() {
		get<Notifications.MetaData> {
			val mapper = if (call.user.scope == EUserScope.Root) {
				notificationMapper + userMapper
			} else {
				notificationMapper
			}
			call.respond(mapper.getMapperData())
		}
	}

	private fun Route.seenAll() {
		put<Notifications.Seen> {
			notificationService.setAllRead(call.user)
			call.respond(HttpStatusCode.OK)
		}
	}

	private fun Route.seenNotification() {
		put<Notifications.Id.Seen> {
			val notification = notificationService.getNotificationById(call.user, it.id.id)
				?: return@put call.respond(HttpStatusCode.NotFound, "Aucune notification trouvé")
			notificationService.setNotificationSeen(notification, true)
			call.respond(TNotification(notification))
		}
	}
}