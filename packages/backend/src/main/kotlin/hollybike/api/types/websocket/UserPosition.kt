package hollybike.api.types.websocket

import hollybike.api.repository.UserEventPosition
import kotlinx.datetime.Instant
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
@SerialName("send-user-position")
data class UserSendPosition(
	val latitude: Double,
	val longitude: Double,
	val altitude: Double,
	val time: Instant,
	val speed: Double
): Body

@Serializable
@SerialName("receive-user-position")
data class UserReceivePosition(
	val latitude: Double,
	val longitude: Double,
	val altitude: Double,
	val time: Instant,
	val speed: Double,
	val user: Int
): Body {
	constructor(data: UserEventPosition): this(
		data.latitude,
		data.longitude,
		data.altitude,
		data.time,
		data.speed,
		data.user.id.value
	)
}
