package hollybike.api.repository.events.participations

import hollybike.api.repository.Users
import hollybike.api.repository.events.Events
import org.jetbrains.exposed.dao.id.IntIdTable

object EventParticipations: IntIdTable("users_participate_events", "id_participation") {
	val user = reference("user", Users)
	val event = reference("event", Events)
	val role = integer("role")
}
