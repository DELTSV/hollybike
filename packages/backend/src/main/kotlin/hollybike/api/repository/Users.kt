package hollybike.api.repository

import hollybike.api.types.user.EUserScope
import hollybike.api.types.user.EUserStatus
import org.jetbrains.exposed.dao.IntEntity
import org.jetbrains.exposed.dao.IntEntityClass
import org.jetbrains.exposed.dao.id.EntityID
import org.jetbrains.exposed.dao.id.IntIdTable
import org.jetbrains.exposed.sql.kotlin.datetime.timestamp

object Users: IntIdTable("users", "id_user") {
	val email = varchar("email", 1_000)
	val username = varchar("username", 1_000)
	val password = varchar("password", 1_000)
	val status = integer("status")
	val scope = integer("scope")
	val association = reference("association", Associations)
	val lastLogin = timestamp("last_login")
	val profilePicture = varchar("profile_picture", 2_048).nullable().default(null)
}

class User(id: EntityID<Int>): IntEntity(id) {
	var email by Users.email
	var username by Users.username
	var password by Users.password
	var status by Users.status.transform({ it.value }, { EUserStatus[it] })
	var scope by Users.scope.transform({ it.value }, { EUserScope[it] })
	var association by Association referencedOn Users.association
	var lastLogin by Users.lastLogin
	var profilePicture by Users.profilePicture

	companion object: IntEntityClass<User>(Users)
}