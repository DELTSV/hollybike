/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.types.event.image

import hollybike.api.repository.EventImage
import hollybike.api.types.event.TEventPartial
import hollybike.api.types.position.TPosition
import hollybike.api.types.user.TUserPartial
import kotlinx.datetime.Instant
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class TEventImageDetails(
	val id: Int,
	val owner: TUserPartial,
	val event: TEventPartial,
	val isOwner: Boolean,
	val position: TPosition?,
	@SerialName("taken_date_time") val takenDateTime: Instant? = null,
	@SerialName("uploaded_date_time") val uploadedDateTime: Instant,
) {
	constructor(entity: EventImage, isOwner: Boolean) : this(
		id = entity.id.value,
		owner = TUserPartial(entity.owner),
		event = TEventPartial(entity.event),
		isOwner = isOwner,
		position = entity.position?.let { TPosition(it) },
		takenDateTime = entity.takenDateTime,
		uploadedDateTime = entity.uploadDateTime,
	)
}