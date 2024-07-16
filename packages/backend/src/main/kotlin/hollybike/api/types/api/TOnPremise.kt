/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.types.api

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class TOnPremise(
	@SerialName("is_on_premise")
	val isOnPremise: Boolean,
)