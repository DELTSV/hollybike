package hollybike.api.types.websocket

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
@SerialName("subscribe")
data class Subscribe(
	val token: String,
	var user: Int? = null
): Body
