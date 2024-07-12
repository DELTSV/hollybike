package hollybike.api.types.websocket

import hollybike.api.json
import hollybike.api.repository.Notification
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class TNotification(
	val data: Body,
	val user: Int,
	val id: Int
) {
	constructor(notification: Notification): this(
		json.decodeFromString(notification.data),
		notification.user.id.value,
		notification.id.value
	)
}

@Serializable
sealed class NotificationBody(
	@SerialName("notification_id")
	var notificationId: Int
): Body