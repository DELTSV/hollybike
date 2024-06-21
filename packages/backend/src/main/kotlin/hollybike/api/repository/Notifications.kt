package hollybike.api.repository

import hollybike.api.utils.search.Mapper
import kotlinx.datetime.Clock
import org.jetbrains.exposed.dao.IntEntity
import org.jetbrains.exposed.dao.IntEntityClass
import org.jetbrains.exposed.dao.id.EntityID
import org.jetbrains.exposed.dao.id.IntIdTable
import org.jetbrains.exposed.sql.kotlin.datetime.timestamp

object Notifications: IntIdTable("notifications", "id_notification") {
	val user = reference("user", Users)
	val data = text("data")
	val creation = timestamp("creation").default(Clock.System.now())
	val seen = bool("seen").default(false)
}

class Notification(id: EntityID<Int>) : IntEntity(id) {
	var user by User referencedOn Notifications.user
	var data by Notifications.data
	var creation by Notifications.creation
	var seen by Notifications.seen

	companion object: IntEntityClass<Notification>(Notifications)
}

val notificationMapper: Mapper = mapOf(
	"id_notification" to Notifications.id,
	"creation" to Notifications.creation,
	"seen" to Notifications.seen,
)