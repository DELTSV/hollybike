package hollybike.api.repository

import hollybike.api.signatureService
import hollybike.api.types.event.EEventStatus
import hollybike.api.utils.search.Mapper
import kotlinx.datetime.Clock
import org.jetbrains.exposed.dao.IntEntity
import org.jetbrains.exposed.dao.IntEntityClass
import org.jetbrains.exposed.dao.id.EntityID
import org.jetbrains.exposed.dao.id.IntIdTable
import org.jetbrains.exposed.sql.alias
import org.jetbrains.exposed.sql.kotlin.datetime.timestamp

object Events : IntIdTable("events", "id_event") {
	val name = varchar("name", 1_000)
	val description = varchar("description", 1_000).nullable().default(null)
	val association = reference("association", Associations)
	val image = varchar("image", 2_048).nullable().default(null)
	val status = integer("status")
	val owner = reference("owner", Users)
	val journey = reference("journey", Journeys).nullable().default(null)
	val startDateTime = timestamp("start_date_time")
	val endDateTime = timestamp("end_date_time").nullable().default(null)
	val createDateTime = timestamp("create_date_time").clientDefault { Clock.System.now() }
	val updateDateTime = timestamp("update_date_time").clientDefault { Clock.System.now() }
}

class Event(id: EntityID<Int>) : IntEntity(id) {
	var name by Events.name
	var description by Events.description
	var association by Association referencedOn Events.association
	var image by Events.image
	val signedImage by Events.image.transform({ it }, { it?.let { signatureService.sign(it) } })
	val participants by EventParticipation referrersOn EventParticipations.event
	var status by Events.status.transform({ it.value }, { EEventStatus[it] })
	var owner by User referencedOn Events.owner
	var journey by Journey optionalReferencedOn Events.journey
	var startDateTime by Events.startDateTime
	var endDateTime by Events.endDateTime
	var createDateTime by Events.createDateTime
	var updateDateTime by Events.updateDateTime

	companion object : IntEntityClass<Event>(Events)
}

val eventMapper: Mapper = mapOf(
	"id_event" to Events.id,
	"name_event" to Events.name,
	"description_event" to Events.description,
	"image_event" to Events.image,
	"status_event" to Events.status,
	"start_date_time" to Events.startDateTime,
	"end_date_time" to Events.endDateTime,
	"create_date_time_event" to Events.createDateTime,
	"update_date_time_event" to Events.updateDateTime,
	"participant_id" to Users.alias("participant")[Users.id],
)