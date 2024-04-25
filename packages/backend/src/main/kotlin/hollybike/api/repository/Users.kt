package hollybike.api.repository

import org.jetbrains.exposed.dao.IntEntity
import org.jetbrains.exposed.dao.IntEntityClass
import org.jetbrains.exposed.dao.id.EntityID
import org.jetbrains.exposed.dao.id.IntIdTable
import org.jetbrains.exposed.sql.kotlin.datetime.timestamp

object Users : IntIdTable("users", "id_user") {
	val email = varchar("email", 1_000)
	val username = varchar("username", 1_000)
	val password = varchar("password", 1_000)
	val status = integer("status")
	val scope = integer("scope")
	val association = reference("association", Associations)
	val lastLogin = timestamp("last_login")
}

class User(id: EntityID<Int>) : IntEntity(id) {
	var email by Users.email
	var username by Users.username
	var password by Users.password
	var status by Users.status
	var scope by Users.scope
	var association by Association referencedOn Users.association
	var lastLogin by Users.lastLogin

	companion object : IntEntityClass<User>(Users)
}