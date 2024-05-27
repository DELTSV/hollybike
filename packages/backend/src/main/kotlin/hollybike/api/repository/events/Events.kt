package hollybike.api.repository.events

import hollybike.api.repository.Associations
import hollybike.api.repository.Users
import hollybike.api.utils.search.Mapper
import kotlinx.datetime.Clock
import org.jetbrains.exposed.dao.id.IntIdTable
import org.jetbrains.exposed.sql.kotlin.datetime.timestamp

object Events : IntIdTable("events", "id_event") {
	val name = varchar("name", 1_000)
	val description = varchar("description", 1_000).nullable().default(null)
	val association = reference("association", Associations)
	val image = varchar("image", 2_048).nullable().default(null)
	val status = integer("status")
	val owner = reference("owner", Users)
	val startDateTime = timestamp("start_date_time")
	val endDateTime = timestamp("end_date_time").nullable().default(null)
	val createDateTime = timestamp("create_date_time").clientDefault { Clock.System.now() }
	val updateDateTime = timestamp("update_date_time").clientDefault { Clock.System.now() }
}

val eventMapper: Mapper = mapOf(
	"id" to Events.id,
	"name" to Events.name,
	"description" to Events.description,
	"image" to Events.image,
	"status" to Events.status,
	"start_date_time" to Events.startDateTime,
	"end_date_time" to Events.endDateTime,
	"create_date_time" to Events.createDateTime,
	"update_date_time" to Events.updateDateTime
)