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
	val speed: Double,
	val heading: Double,
	@SerialName("acceleration_x")
	val accelerationX: Double,
	@SerialName("acceleration_y")
	val accelerationY: Double,
	@SerialName("acceleration_z")
	val accelerationZ: Double,
	val accuracy: Double,
	@SerialName("speed_accuracy")
	val speedAccuracy: Double
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

@Serializable
@SerialName("stop-send-user-position")
data object StopUserSendPosition : Body

@Serializable
@SerialName("stop-receive-user-position")
data class StopUserReceivePosition(
	val user: Int
): Body