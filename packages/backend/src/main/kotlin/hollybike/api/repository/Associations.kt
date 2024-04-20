package hollybike.api.repository

import org.ktorm.database.Database
import org.ktorm.entity.Entity
import org.ktorm.entity.sequenceOf
import org.ktorm.schema.Table
import org.ktorm.schema.int
import org.ktorm.schema.varchar

object Associations: Table<Association>("associations") {
	val id = int("id_association").primaryKey().bindTo { it.id }
	val name = varchar("name").bindTo { it.name }
	val status = int("status").bindTo { it.status }
}

interface Association: Entity<Association> {
	val id: Int
	val name: String
	val status: Int
}

val Database.associations get() = sequenceOf(Associations)
