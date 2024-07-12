package hollybike.api.types.websocket

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
@SerialName("AddedToEventNotification")
data class AddedToEventNotification(
	val id: Int,
	val name: String
): NotificationBody(0)