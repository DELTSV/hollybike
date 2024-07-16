/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.types.journey

import kotlinx.serialization.Serializable

@Serializable
data class TNewJourney(
	val name: String,
	val association: Int? = null
)
