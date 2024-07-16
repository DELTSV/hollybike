/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.types.event.participation

import kotlinx.serialization.Serializable

@Serializable
data class TCreateParticipations(
	val userIds: List<Int>
)