package hollybike.api.repository.events.participations

import hollybike.api.repository.User
import hollybike.api.repository.events.Event
import hollybike.api.types.event.EEventRole
import org.jetbrains.exposed.dao.IntEntity
import org.jetbrains.exposed.dao.IntEntityClass
import org.jetbrains.exposed.dao.id.EntityID

class EventParticipation(id: EntityID<Int>) : IntEntity(id) {
	var user by User referencedOn EventParticipations.user
	var event by Event referencedOn EventParticipations.event
	var role by EventParticipations.role.transform({ it.value }, { EEventRole[it] })
	var joinedDateTime by EventParticipations.joinedDateTime

	companion object : IntEntityClass<EventParticipation>(EventParticipations)
}