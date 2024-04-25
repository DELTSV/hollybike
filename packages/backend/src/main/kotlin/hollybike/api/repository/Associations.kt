package hollybike.api.repository

import hollybike.api.types.association.EAssociationsStatus
import org.jetbrains.exposed.dao.IntEntity
import org.jetbrains.exposed.dao.IntEntityClass
import org.jetbrains.exposed.dao.id.EntityID
import org.jetbrains.exposed.dao.id.IntIdTable

object Associations : IntIdTable("associations", "id_association") {
	val name = varchar("name", 1_000)
	val status = integer("status").default(1)
	val picture = varchar("picture", 2_048).nullable().default(null)
}

class Association(id: EntityID<Int>) : IntEntity(id) {
	companion object : IntEntityClass<Association>(Associations)

	var name by Associations.name
	var status by Associations.status.transform({ it.value }, { EAssociationsStatus[it] })
	var picture by Associations.picture
}
