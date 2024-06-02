package hollybike.api.repository

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
	var path by EventImages.path
	var size by EventImages.size
	var uploadDateTime by EventImages.uploadDateTime

	companion object : IntEntityClass<EventImage>(EventImages)
}

object EventImages: IntIdTable("event_images", "id_event_image") {
	val owner = reference("owner", Users)
	val event = reference("event", Events)
	val path = varchar("path", 2_048)
	val size = integer("size")
	val uploadDateTime = timestamp("upload_date_time").clientDefault { Clock.System.now() }
}

val eventImagesMapper: Mapper = mapOf(
	"id_image" to EventImages.id,
	"owner_image" to EventImages.owner,
	"size" to EventImages.size,
	"upload_date_time" to EventImages.uploadDateTime
)