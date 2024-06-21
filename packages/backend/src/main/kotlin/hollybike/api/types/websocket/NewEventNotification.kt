package hollybike.api.types.websocket

import kotlinx.datetime.Instant
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
@SerialName("NewEventNotification")
data class NewEventNotification(
	val id: Int,
	val name: String,
	val description: String? = null,
	val start: Instant,
	val image: String? = null,
	val ownerId: Int,
	val owneName: String
): Body
