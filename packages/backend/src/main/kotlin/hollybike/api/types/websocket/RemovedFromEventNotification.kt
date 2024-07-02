package hollybike.api.types.websocket

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
@SerialName("RemovedFromEventNotification")
data class RemovedFromEventNotification(
	val id: Int,
	val name: String
): Body
