package hollybike.api.types.websocket

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
@SerialName("unsubscribed")
data class Unsubscribed(
	val unsubscribed: Boolean
): Body

@Serializable
@SerialName("unsubscribe")
data object Unsubscribe : Body
