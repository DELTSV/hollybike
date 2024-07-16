/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.types.event.image

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class TUpdateImagesVisibility(
	@SerialName("is_images_public") val isImagesPublic: Boolean
)