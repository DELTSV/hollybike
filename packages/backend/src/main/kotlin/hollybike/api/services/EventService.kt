package hollybike.api.services

import hollybike.api.repository.User
import hollybike.api.repository.events.Event
import hollybike.api.repository.events.Events
import hollybike.api.types.event.EEventStatus
import org.jetbrains.exposed.dao.with
import org.jetbrains.exposed.sql.Database
import org.jetbrains.exposed.sql.Op
import org.jetbrains.exposed.sql.SqlExpressionBuilder.eq
import org.jetbrains.exposed.sql.SqlExpressionBuilder.neq
import org.jetbrains.exposed.sql.and
import org.jetbrains.exposed.sql.or
import org.jetbrains.exposed.sql.transactions.transaction

class EventService(
	private val db: Database,
) {
	fun getEvents(caller: User, perPage: Int, page: Int): List<Event> = transaction(db) {
		Event.find {
			eventUserCondition(caller)
		}.limit(perPage, offset = (page * perPage).toLong()).with(Event::owner).toList()
	}

	fun countEvents(caller: User): Int = transaction(db) {
		Event.find {
			eventUserCondition(caller)
		}.count().toInt()
	}

	private fun eventUserCondition(caller: User): Op<Boolean> = (Events.owner eq caller.id)
		.and(Events.status eq EEventStatus.PENDING.value)
		.or(Events.status neq EEventStatus.PENDING.value)
		.and(Events.association eq caller.association.id)

	fun getEvent(caller: User, id: Int): Event? = transaction(db) {
		Event.find {
			Events.id eq id and eventUserCondition(caller)
		}.with(Event::owner).with(Event::participants).firstOrNull()
	}
}