/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.types.event

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class TAddJourneyToEvent(
	@SerialName("journey_id")
	val journeyId: Int,
)
