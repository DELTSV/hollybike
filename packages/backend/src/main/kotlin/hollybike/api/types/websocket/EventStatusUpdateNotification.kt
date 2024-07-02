package hollybike.api.types.websocket

import hollybike.api.repository.Event
import hollybike.api.types.event.EEventStatus
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
@SerialName("EventStatusUpdateNotification")
data class EventStatusUpdateNotification(
	val id: Int,
	val name: String,
	val description: String? = null,
	val image: String? = null,
	val status: EEventStatus
): Body {
	constructor(event: Event): this(
		event.id.value,
		event.name,
		event.description,
		event.image,
		event.status
	)
}
