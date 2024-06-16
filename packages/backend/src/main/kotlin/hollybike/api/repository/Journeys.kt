package hollybike.api.repository

import hollybike.api.signatureService
import hollybike.api.utils.search.Mapper
import kotlinx.datetime.Clock
import org.jetbrains.exposed.dao.IntEntity
import org.jetbrains.exposed.dao.IntEntityClass
import org.jetbrains.exposed.dao.id.EntityID
import org.jetbrains.exposed.dao.id.IntIdTable
import org.jetbrains.exposed.sql.kotlin.datetime.timestamp

object Journeys: IntIdTable("journeys", "id_journey") {
	val file = varchar("file", 2_048).nullable().default(null)
	val name = varchar("name", 1_000)
	val createdAt = timestamp("created_at").default(Clock.System.now())
	val creator = reference("creator", Users)
	val association = reference("association", Associations)
	val start = reference("start", Positions).nullable().default(null)
	val end = reference("end", Positions).nullable().default(null)
}

class Journey(id: EntityID<Int>) : IntEntity(id) {
	var file by Journeys.file
	val signedFile by Journeys.file.transform( { it }, { it?.let { signatureService.sign(it) }})
	var name by Journeys.name
	var createdAt by Journeys.createdAt
	var creator by User referencedOn Journeys.creator
	var association by Association referencedOn Journeys.association
	var start by Position optionalReferencedOn Journeys.start
	var end by Position optionalReferencedOn Journeys.end

	companion object: IntEntityClass<Journey>(Journeys)
}

val journeysMapper: Mapper = mapOf(
	"journey_name" to Journeys.name,
	"created_at" to Journeys.createdAt
)
