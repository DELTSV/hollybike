package hollybike.api.types.auth

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class TAuthInfo(
	val token: String,
	@SerialName("refresh_token")
	val refreshToken: String,
	val deviceId: String
)
