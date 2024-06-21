package hollybike.api.types.websocket

import hollybike.api.repository.User
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
@SerialName("subscribe")
data class Subscribe(
	val token: String,
	var user: Int? = null
): Body
