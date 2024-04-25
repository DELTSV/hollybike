package hollybike.api.repository

import org.jetbrains.exposed.dao.IntEntity
import org.jetbrains.exposed.dao.IntEntityClass
import org.jetbrains.exposed.dao.id.EntityID
import org.jetbrains.exposed.dao.id.IntIdTable

object Associations : IntIdTable("associations", "id_association") {
	val name = varchar("name", 1_000)
	val status = integer("status")
}

class Association(id: EntityID<Int>) : IntEntity(id) {
	companion object : IntEntityClass<Association>(Associations)

	val name by Associations.name
	val status by Associations.status
}
