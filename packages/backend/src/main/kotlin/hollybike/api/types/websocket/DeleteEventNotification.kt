/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.types.websocket

import hollybike.api.repository.Event
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
@SerialName("DeleteEventNotification")
data class DeleteEventNotification(
	val name: String,
	val description: String? = null,
): NotificationBody(0) {
	constructor(event: Event): this(
		event.name,
		event.description
	)
}
