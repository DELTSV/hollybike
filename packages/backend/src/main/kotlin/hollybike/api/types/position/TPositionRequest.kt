/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.types.position

data class TPositionRequest(
	val latitude: Double,
	val longitude: Double,
	val altitude: Double? = null,
	val scope: EPositionScope
)
