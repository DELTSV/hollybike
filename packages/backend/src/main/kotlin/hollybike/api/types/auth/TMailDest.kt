/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.types.auth

import kotlinx.serialization.Serializable

@Serializable
data class TMailDest(
	val dest: String
)
