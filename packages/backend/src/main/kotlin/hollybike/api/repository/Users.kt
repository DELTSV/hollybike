package hollybike.api.repository

import kotlinx.datetime.Instant
import org.ktorm.database.Database
import org.ktorm.entity.Entity
import org.ktorm.entity.sequenceOf
import org.ktorm.schema.Table
import org.ktorm.schema.blob
import org.ktorm.schema.int
import org.ktorm.schema.varchar

object Users: Table<User>("users") {
	val id = int("id_user").primaryKey().bindTo { it.id }
	val email = varchar("email").bindTo { it.email }
	val username = varchar("username").bindTo { it.username }
	val password = varchar("password").bindTo { it.password }
	val status = int("status").bindTo { it.status }
	val scope = int("scope").bindTo { it.scope }
	val association = int("association").references(Associations) { it.association }
	val lastLogin = datetime("last_login").bindTo { it.lastLogin }

	val associations: Associations get() = association.referenceTable as Associations
}

interface User: Entity<User> {
	val id: Int
	var email: String
	var username: String
	var password: String
	var status: Int
	var scope: Int
	var association: Association
	var lastLogin: Instant

	companion object: Entity.Factory<User>()
}

val Database.users get() = this.sequenceOf(Users)