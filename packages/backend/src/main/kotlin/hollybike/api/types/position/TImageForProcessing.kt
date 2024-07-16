/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.types.position

import hollybike.api.repository.EventImage
import hollybike.api.types.event.image.TImageMetadata

class TImageForProcessing(
	val entity: EventImage,
	val contentType: String,
	val data: ByteArray,
	val position: TImageMetadata.Position?
)