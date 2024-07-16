/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.types.auth

import hollybike.api.types.user.EUserScope
import kotlinx.serialization.Serializable

@Serializable
data class TSignup(
	val email: String,
	val password: String,
	val username: String,
	val verify: String,
	val association: Int,
	val role: EUserScope,
	val invitation: Int
)
