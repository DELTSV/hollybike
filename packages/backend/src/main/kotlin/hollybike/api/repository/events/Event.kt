package hollybike.api.repository.events

import hollybike.api.repository.Association
import hollybike.api.repository.User
import hollybike.api.types.event.EEventStatus
import org.jetbrains.exposed.dao.IntEntity
import org.jetbrains.exposed.dao.IntEntityClass
import org.jetbrains.exposed.dao.id.EntityID

class Event(id: EntityID<Int>) : IntEntity(id) {
	var name by Events.name
	var description by Events.description
	var association by Association referencedOn Events.association
	var image by Events.image
	var status by Events.status.transform({ it.value }, { EEventStatus[it] })
	var owner by User referencedOn Events.owner
	var startDateTime by Events.startDateTime
	var endDateTime by Events.endDateTime
	var createDateTime by Events.createDateTime
	var updateDateTime by Events.updateDateTime

	companion object : IntEntityClass<Event>(Events)
}