/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.types.event.image

import hollybike.api.repository.EventImage
import kotlinx.serialization.Serializable

@Serializable
data class TEventImage(
	val id: Int,
	val url: String,
	val key: String,
	val size: Int,
	val width: Int,
	val height: Int,
) {
	constructor(entity: EventImage) : this(
		id = entity.id.value,
		url = entity.signedPath,
		key = entity.path,
		size = entity.size,
		width = entity.width,
		height = entity.height,
	)
}