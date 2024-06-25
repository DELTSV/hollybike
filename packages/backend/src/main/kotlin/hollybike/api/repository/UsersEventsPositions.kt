package hollybike.api.repository

import org.jetbrains.exposed.dao.IntEntity
import org.jetbrains.exposed.dao.IntEntityClass
import org.jetbrains.exposed.dao.id.EntityID
import org.jetbrains.exposed.dao.id.IntIdTable
import org.jetbrains.exposed.sql.kotlin.datetime.timestamp

object UsersEventsPositions: IntIdTable("users_events_positions", "id_user_event_position") {
	val user = reference("user", Users)
	val event = reference("event", Events)
	val latitude = double("latitude")
	val longitude = double("longitude")
	val altitude = double("altitude")
	val time = timestamp("time")
	val speed = double("speed")
}

class UserEventPosition(id: EntityID<Int>) : IntEntity(id) {
	var user by User referencedOn UsersEventsPositions.user
	var event by Event referencedOn UsersEventsPositions.event
	var latitude by UsersEventsPositions.latitude
	var longitude by UsersEventsPositions.longitude
	var altitude by UsersEventsPositions.altitude
	var time by UsersEventsPositions.time
	var speed by UsersEventsPositions.speed

	companion object : IntEntityClass<UserEventPosition>(UsersEventsPositions)
}