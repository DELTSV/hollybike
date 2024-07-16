/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.repository

import hollybike.api.signatureService
import hollybike.api.utils.search.Mapper
import kotlinx.datetime.Clock
import org.jetbrains.exposed.dao.IntEntity
import org.jetbrains.exposed.dao.IntEntityClass
import org.jetbrains.exposed.dao.id.EntityID
import org.jetbrains.exposed.dao.id.IntIdTable
import org.jetbrains.exposed.sql.kotlin.datetime.timestamp

class EventImage(id: EntityID<Int>) : IntEntity(id) {
	var owner by User referencedOn EventImages.owner
	var event by Event referencedOn EventImages.event
	val signedPath by EventImages.path.transform({ it }, { signatureService.sign(it) })
	var path by EventImages.path
	var size by EventImages.size
	var width by EventImages.width
	var height by EventImages.height
	var uploadDateTime by EventImages.uploadDateTime
	var takenDateTime by EventImages.takenDateTime
	var position by Position optionalReferencedOn EventImages.position

	companion object : IntEntityClass<EventImage>(EventImages)
}

object EventImages: IntIdTable("event_images", "id_event_image") {
	val owner = reference("owner", Users)
	val event = reference("event", Events)
	val path = varchar("path", 2_048)
	val size = integer("size")
	val width = integer("width")
	val height = integer("height")
	val uploadDateTime = timestamp("upload_date_time").clientDefault { Clock.System.now() }
	val takenDateTime = timestamp("taken_date_time").nullable()
	val position = reference("position", Positions).nullable()
}

val eventImagesMapper: Mapper = mapOf(
	"id_image" to EventImages.id,
	"owner_image" to EventImages.owner,
	"size" to EventImages.size,
	"taken_date_time" to EventImages.takenDateTime,
	"upload_date_time" to EventImages.uploadDateTime
)