package hollybike.api.types.websocket

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
@SerialName("read-notification")
data class ReadNotification(
	val notification: Int
): Body
