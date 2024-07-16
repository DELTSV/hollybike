/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.types.position

data class TPositionMessage(val topic: String, val identifier: Int, val content: TPositionRequest)
