package hollybike.api.types.websocket

import hollybike.api.repository.Event
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
@SerialName("DeleteEventNotification")
data class DeleteEventNotification(
	val name: String,
	val description: String? = null,
): Body {
	constructor(event: Event): this(
		event.name,
		event.description
	)
}
