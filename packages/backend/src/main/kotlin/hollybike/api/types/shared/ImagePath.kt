/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.types.shared

import kotlinx.serialization.Serializable

@Serializable
data class ImagePath(val path: String, val key: String)