package hollybike.api.repository

import hollybike.api.types.event.EEventRole
import kotlinx.datetime.Clock
import org.jetbrains.exposed.dao.IntEntity
import org.jetbrains.exposed.dao.IntEntityClass
import org.jetbrains.exposed.dao.id.EntityID
import org.jetbrains.exposed.dao.id.IntIdTable
import org.jetbrains.exposed.sql.kotlin.datetime.timestamp

class EventParticipation(id: EntityID<Int>) : IntEntity(id) {
	var user by User referencedOn EventParticipations.user
	var event by Event referencedOn EventParticipations.event
	var role by EventParticipations.role.transform({ it.value }, { EEventRole[it] })
	var isImagesPublic by EventParticipations.isImagesPublic
	var joinedDateTime by EventParticipations.joinedDateTime

	companion object : IntEntityClass<EventParticipation>(EventParticipations)
}

object EventParticipations: IntIdTable("users_participate_events", "id_participation") {
	val user = reference("user", Users)
	val event = reference("event", Events)
	val role = integer("role")
	val isImagesPublic = bool("is_images_public").default(true)
	val joinedDateTime = timestamp("joined_date_time").clientDefault { Clock.System.now() }
}
