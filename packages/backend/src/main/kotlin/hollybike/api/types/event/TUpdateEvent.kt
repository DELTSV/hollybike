/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.types.event

import kotlinx.datetime.Instant
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class TUpdateEvent(
	val name: String,
	val description: String? = null,
	@SerialName("start_date")
	val startDate: Instant,
	@SerialName("end_date")
	val endDate: Instant? = null,
	val budget: Int? = null
)
