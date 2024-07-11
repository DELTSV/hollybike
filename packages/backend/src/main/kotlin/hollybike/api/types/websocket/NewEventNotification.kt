package hollybike.api.types.websocket

import hollybike.api.repository.Event
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
): Body {
	constructor(entity: Event): this(
		entity.id.value,
		entity.name,
		entity.description,
		entity.startDateTime,
		entity.image,
		entity.owner.id.value,
		entity.owner.username
	)
}
