/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.types.event.image

import kotlinx.datetime.Instant

data class TImageMetadata(
	val takenDateTime: Instant?,
	val position: Position?,
) {
	data class Position(
		val latitude: Double,
		val longitude: Double,
		val altitude: Double?,
	)
}
