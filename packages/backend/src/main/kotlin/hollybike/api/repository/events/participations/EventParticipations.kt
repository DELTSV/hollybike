package hollybike.api.repository.events.participations

import hollybike.api.repository.Users
import hollybike.api.repository.events.Events
import kotlinx.datetime.Clock
import org.jetbrains.exposed.dao.id.IntIdTable
import org.jetbrains.exposed.sql.kotlin.datetime.timestamp

object EventParticipations: IntIdTable("users_participate_events", "id_participation") {
	val user = reference("user", Users)
	val event = reference("event", Events)
	val role = integer("role")
	val joinedDateTime = timestamp("joined_date_time").clientDefault { Clock.System.now() }
}
