/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.types.user

import kotlinx.serialization.Serializable

@Serializable
data class TUserUpdate(
	val username: String? = null,
	val email: String? = null,
	val password: String? = null,
	val status: EUserStatus? = null,
	val scope: EUserScope? = null,
	val association: Int? = null,
	val role: String? = null
)
