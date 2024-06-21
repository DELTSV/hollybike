package hollybike.api.types.websocket

import hollybike.api.repository.Notification
import kotlinx.serialization.Serializable
import kotlinx.serialization.json.Json

@Serializable
data class TNotification(
	val data: Body,
	val user: Int,
	val id: Int
) {
	constructor(notification: Notification): this(
		Json.decodeFromString(notification.data),
		notification.user.id.value,
		notification.id.value
	)
}
