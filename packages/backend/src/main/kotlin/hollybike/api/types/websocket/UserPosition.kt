package hollybike.api.types.websocket

import kotlinx.datetime.Instant
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
@SerialName("send-user-position")
data class UserSendPosition(
	val latitude: Double,
	val longitude: Double,
	val altitude: Double,
	val time: Instant
): Body

@Serializable
@SerialName("receive-user-position")
data class UserReceivePosition(
	val latitude: Double,
	val longitude: Double,
	val altitude: Double,
	val time: Instant,
	val user: Int
): Body
