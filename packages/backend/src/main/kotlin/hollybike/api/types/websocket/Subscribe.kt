package hollybike.api.types.websocket

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
@SerialName("subscribe")
data class Subscribe(
	val token: String
): Body

@Serializable
@SerialName("subscribed")
data class Subscribed(
	val subscribed: Boolean
): Body
