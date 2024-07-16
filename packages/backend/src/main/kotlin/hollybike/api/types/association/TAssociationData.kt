/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.types.association

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class TAssociationData(
	@SerialName("total_user")
	val totalUser: Long,
	@SerialName("total_event")
	val totalEvent: Long,
	@SerialName("total_event_with_journey")
	val totalEventWithJourney: Long,
	@SerialName("total_journey")
	val totalJourney: Long
)
