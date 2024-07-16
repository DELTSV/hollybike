/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.repository

import org.jetbrains.exposed.dao.IntEntity
import org.jetbrains.exposed.dao.IntEntityClass
import org.jetbrains.exposed.dao.id.EntityID
import org.jetbrains.exposed.dao.id.IntIdTable
import org.jetbrains.exposed.sql.kotlin.datetime.timestamp

object UsersEventsPositions: IntIdTable("users_events_positions", "id_user_event_position") {
	val user = reference("user", Users)
	val event = reference("event", Events)
	val participation = reference("participation", EventParticipations)
	val latitude = double("latitude")
	val longitude = double("longitude")
	val altitude = double("altitude")
	val time = timestamp("time")
	val speed = double("speed")
	val heading = double("heading")
	val accelerationX = double("acceleration_x")
	val accelerationY = double("acceleration_y")
	val accelerationZ = double("acceleration_z")
	val accuracy = double("accuracy")
	val speedAccuracy = double("speed_accuracy")
}

class UserEventPosition(id: EntityID<Int>) : IntEntity(id) {
	var user by User referencedOn UsersEventsPositions.user
	var event by Event referencedOn UsersEventsPositions.event
	var participation by EventParticipation referencedOn UsersEventsPositions.participation
	var latitude by UsersEventsPositions.latitude
	var longitude by UsersEventsPositions.longitude
	var altitude by UsersEventsPositions.altitude
	var time by UsersEventsPositions.time
	var speed by UsersEventsPositions.speed
	var heading by UsersEventsPositions.heading
	var accelerationX by UsersEventsPositions.accelerationX
	var accelerationY by UsersEventsPositions.accelerationY
	var accelerationZ by UsersEventsPositions.accelerationZ
	var accuracy by UsersEventsPositions.accuracy
	var speedAccuracy by UsersEventsPositions.speedAccuracy

	companion object : IntEntityClass<UserEventPosition>(UsersEventsPositions)
}