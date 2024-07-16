/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.types.association

import kotlinx.serialization.Serializable

@Serializable
data class TNewAssociation(
	val name: String
)
