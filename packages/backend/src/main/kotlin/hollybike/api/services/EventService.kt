package hollybike.api.services

import hollybike.api.repository.User
import hollybike.api.repository.events.Event
import org.jetbrains.exposed.sql.Database
import org.jetbrains.exposed.sql.transactions.transaction

class EventService(
	private val db: Database,
) {
	fun getEvents(caller: User, perPage: Int, page: Int): List<Event> = transaction(db) {
		Event.all().limit(perPage, offset = (page * perPage).toLong()).toList()
	}

	fun countEvents(caller: User): Int = transaction(db) {
		Event.all().count().toInt()
	}
}