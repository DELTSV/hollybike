package hollybike.api.services

import hollybike.api.json
import hollybike.api.repository.Notification
import hollybike.api.repository.Notifications
import hollybike.api.repository.User
import hollybike.api.repository.Users
import hollybike.api.types.user.EUserScope
import hollybike.api.types.user.EUserStatus
import hollybike.api.types.websocket.Body
import hollybike.api.types.websocket.TNotification
import hollybike.api.utils.search.SearchParam
import hollybike.api.utils.search.applyParam
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.serialization.encodeToString
import org.jetbrains.exposed.dao.load
import org.jetbrains.exposed.sql.*
import org.jetbrains.exposed.sql.SqlExpressionBuilder.eq
import org.jetbrains.exposed.sql.transactions.transaction

class NotificationService(
	private val db: Database
) {
	private val notificationChannels: MutableMap<Int, MutableSharedFlow<TNotification>> = mutableMapOf()

	fun getUserChannel(userId: Int): MutableSharedFlow<TNotification> = notificationChannels.getOrElse(userId) {
		val new = MutableSharedFlow<TNotification>(15, 15)
		notificationChannels[userId] = new
		return new
	}

	suspend fun send(user: User, notification: Body) {
		val n = transaction(db) {
			Notification.new {
				this.user = user
				this.data = json.encodeToString(notification)
			}
		}
		getUserChannel(user.id.value).emit(TNotification(notification, user.id.value, n.id.value))
	}

	suspend fun send(users: List<User>, notification: Body, caller: User) {
		users.forEach {
			if(caller.id != it.id){
				send(it, notification)
			}
		}
	}

	suspend fun sendToAssociation(associationId: Int, notification: Body, caller: User) {
		val users = transaction(db) {
			User.find { (Users.association eq associationId) and (Users.status neq EUserStatus.Disabled.value) }.toList()
		}
		send(users, notification, caller)
	}

	private fun authorizeGet(caller: User, target: Notification): Boolean = when(caller.scope) {
		EUserScope.Root -> true
		EUserScope.Admin -> target.user.id == caller.id
		EUserScope.User -> target.user.id == caller.id
	}

	private infix fun Notification?.getIfAllowed(caller: User): Notification? =
		this?.let { if(authorizeGet(caller, it)) this else null }

	fun getAll(caller: User, searchParam: SearchParam): List<Notification> = transaction(db) {
		val condition = when(caller.scope) {
			EUserScope.Root -> Op.nullOp()
			EUserScope.Admin -> Notifications.user eq caller.id
			EUserScope.User -> Notifications.user eq caller.id
		}
		Notification.wrapRows(
			Notifications.selectAll().applyParam(searchParam).andWhere { condition }
		).toList()
	}

	fun getAllCount(caller: User, searchParam: SearchParam): Long = transaction(db) {
		val condition = when(caller.scope) {
			EUserScope.Root -> Op.nullOp()
			EUserScope.Admin -> Notifications.user eq caller.id
			EUserScope.User -> Notifications.user eq caller.id
		}
		Notifications.selectAll().applyParam(searchParam, false).andWhere { condition }.count()
	}

	fun setAllRead(caller: User) {
		transaction(db) {
			Notifications.update({ (Notifications.seen eq false) and (Notifications.user eq caller.id) }) {
				it[seen] = true
			}
		}
	}

	fun setNotificationSeen(notification: Notification, seen: Boolean): Notification = transaction(db) {
		notification.apply {
			this.seen = seen
		}
	}

	fun getNotificationById(caller: User, notificationId: Int) = transaction(db) {
		Notification.findById(notificationId)?.load(Notification::user, User::association) getIfAllowed caller
	}
}