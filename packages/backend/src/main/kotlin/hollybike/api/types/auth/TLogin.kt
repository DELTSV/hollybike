/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.types.auth

import kotlinx.serialization.Serializable

@Serializable
data class TLogin(
	val email: String,
	val password: String,
	val device: String? = null
)