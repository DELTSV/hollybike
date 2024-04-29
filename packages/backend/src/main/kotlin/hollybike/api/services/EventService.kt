package hollybike.api.services

import hollybike.api.exceptions.events.AlreadyParticipatingToEvent
import hollybike.api.exceptions.events.EventActionDenied
import hollybike.api.exceptions.events.EventNotFound
import hollybike.api.exceptions.events.NotParticipatingToEvent
import hollybike.api.repository.User
import hollybike.api.repository.events.Event
import hollybike.api.repository.events.Events
import hollybike.api.repository.events.participations.EventParticipation
import hollybike.api.repository.events.participations.EventParticipations
import hollybike.api.types.event.EEventRole
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

	fun getEvent(caller: User, id: Int): Event? = transaction(db) {
		Event.find {
			Events.id eq id and eventUserCondition(caller)
		}.with(Event::owner).with(Event::participants).firstOrNull()
	}

	fun participateEvent(caller: User, eventId: Int): Result<EventParticipation> = transaction(db) {
		Event.find {
			Events.id eq eventId and eventUserCondition(caller)
		}.firstOrNull() ?: return@transaction Result.failure(EventNotFound("Event not found"))

		EventParticipation.find {
			(EventParticipations.user eq caller.id) and (EventParticipations.event eq eventId)
		}.firstOrNull()?.let {
			return@transaction Result.failure(AlreadyParticipatingToEvent("Already participating to this event"))
		}

		Result.success(
			EventParticipation.new {
				user = caller
				event = Event[eventId]
				role = EEventRole.MEMBER
			}
		)
	}

	fun leaveEvent(caller: User, eventId: Int): Result<Unit> = transaction(db) {
		Event.find {
			Events.id eq eventId and eventUserCondition(caller)
		}.firstOrNull() ?: return@transaction Result.failure(EventNotFound("Event not found"))

		EventParticipation.find {
			(EventParticipations.user eq caller.id) and (EventParticipations.event eq eventId)
		}.firstOrNull()?.delete()
			?: return@transaction Result.failure(NotParticipatingToEvent("Not participating to this event"))

		Result.success(Unit)
	}

	fun promoteParticipant(caller: User, eventId: Int, userId: Int): Result<EventParticipation> = transaction(db) {
		Event.find {
			Events.id eq eventId and eventUserCondition(caller)
		}.firstOrNull() ?: return@transaction Result.failure(EventNotFound("Event not found"))

		EventParticipation.find {
			(EventParticipations.user eq caller.id) and (EventParticipations.event eq eventId)
		}.firstOrNull()?.apply {
			if (role != EEventRole.ORGANIZER) {
				return@transaction Result.failure(EventActionDenied("Only organizer can promote participant"))
			}
		} ?: return@transaction Result.failure(NotParticipatingToEvent("Not participating to this event"))

		Result.success(
			EventParticipation.find {
				(EventParticipations.user eq userId) and (EventParticipations.event eq eventId)
			}.firstOrNull()?.apply {
				if (role == EEventRole.MEMBER) {
					role = EEventRole.ORGANIZER
				} else {
					return@transaction Result.failure(EventActionDenied("Only member can be promoted"))
				}
			} ?: return@transaction Result.failure(NotParticipatingToEvent("User not participating to this event"))
		)
	}

	fun demoteParticipant(caller: User, eventId: Int, userId: Int): Result<EventParticipation> = transaction(db) {
		Event.find {
			Events.id eq eventId and eventUserCondition(caller)
		}.firstOrNull() ?: return@transaction Result.failure(EventNotFound("Event not found"))

		EventParticipation.find {
			(EventParticipations.user eq caller.id) and (EventParticipations.event eq eventId)
		}.firstOrNull()?.apply {
			if (role != EEventRole.ORGANIZER) {
				return@transaction Result.failure(EventActionDenied("Only organizer can demote participant"))
			}
		} ?: return@transaction Result.failure(NotParticipatingToEvent("Not participating to this event"))

		Result.success(
			EventParticipation.find {
				(EventParticipations.user eq userId) and (EventParticipations.event eq eventId)
			}.firstOrNull()?.apply {
				if (role == EEventRole.ORGANIZER) {
					role = EEventRole.MEMBER
				} else {
					return@transaction Result.failure(EventActionDenied("Only organizer can be demoted"))
				}
			} ?: return@transaction Result.failure(NotParticipatingToEvent("User not participating to this event"))
		)
	}

	private fun eventUserCondition(caller: User): Op<Boolean> = (Events.owner eq caller.id)
		.and(Events.status eq EEventStatus.PENDING.value)
		.or(Events.status neq EEventStatus.PENDING.value)
		.and(Events.association eq caller.association.id)
}