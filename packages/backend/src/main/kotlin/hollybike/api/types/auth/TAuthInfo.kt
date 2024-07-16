/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
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
