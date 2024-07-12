package hollybike.api.repository

import hollybike.api.types.event.participation.EEventRole
import hollybike.api.utils.search.Mapper
import kotlinx.datetime.Clock
import org.jetbrains.exposed.dao.IntEntity
import org.jetbrains.exposed.dao.IntEntityClass
import org.jetbrains.exposed.dao.id.EntityID
import org.jetbrains.exposed.dao.id.IntIdTable
import org.jetbrains.exposed.sql.kotlin.datetime.timestamp

class EventParticipation(id: EntityID<Int>) : IntEntity(id) {
	var user by User referencedOn EventParticipations.user
	var event by Event referencedOn EventParticipations.event
	var role by EventParticipations.role.transform({ it.value }, { EEventRole[it] })
	var isJoined by EventParticipations.isJoined
	var isImagesPublic by EventParticipations.isImagesPublic
	var joinedDateTime by EventParticipations.joinedDateTime
	var leftDateTime by EventParticipations.leftDateTime
	var journey by UserJourney optionalReferencedOn EventParticipations.journey

	val recordedPositions by UserEventPosition referrersOn UsersEventsPositions.participation

	val hasRecordedPositions: Boolean
		get() = recordedPositions.count() >= 2

	companion object : IntEntityClass<EventParticipation>(EventParticipations)
}

object EventParticipations : IntIdTable("event_participations", "id_participation") {
	val user = reference("user", Users)
	val event = reference("event", Events)
	val role = integer("role")
	val isImagesPublic = bool("is_images_public").default(true)
	val isJoined = bool("is_joined").default(true)
	val joinedDateTime = timestamp("joined_date_time").clientDefault { Clock.System.now() }
	val leftDateTime = timestamp("left_date_time").nullable()
	val journey = reference("journey", UsersJourneys).nullable().default(null)
}

val eventParticipationMapper: Mapper = mapOf(
	"joined_date_time" to EventParticipations.joinedDateTime,
)