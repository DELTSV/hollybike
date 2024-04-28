package hollybike.api.services

import hollybike.api.repository.events.Event
import org.jetbrains.exposed.sql.Database
import org.jetbrains.exposed.sql.transactions.transaction

class EventService(
	private val db: Database,
) {
	fun getEvents(): List<Event> = transaction(db) {
		Event.all().toList()
	}
}