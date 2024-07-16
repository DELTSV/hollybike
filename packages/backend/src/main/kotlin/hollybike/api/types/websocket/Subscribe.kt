/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.types.websocket

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
@SerialName("subscribe")
data class Subscribe(
	val token: String
): Body

@Serializable
@SerialName("subscribed")
data class Subscribed(
	val subscribed: Boolean
): Body
