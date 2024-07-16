/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.types.websocket

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
@SerialName("unsubscribed")
data class Unsubscribed(
	val unsubscribed: Boolean
): Body

@Serializable
@SerialName("unsubscribe")
data object Unsubscribe : Body
