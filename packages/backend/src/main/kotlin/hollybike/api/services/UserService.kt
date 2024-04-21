package hollybike.api.services

import hollybike.api.repository.User
import hollybike.api.repository.Users
import org.jetbrains.exposed.sql.Database
import org.jetbrains.exposed.sql.transactions.transaction

class UserService(
	private val db: Database
) {
	fun getUser(caller: User?, id: Int): User? = transaction(db) {
		val user = User.find { Users.id eq id }.singleOrNull()
		if (caller != null && caller.association != user?.association && caller.scope != 2) {
			null
		} else {
			user
		}
	}

	fun getUserByEmail(caller: User?, email: String): User? = transaction(this.db) {
		val user = User.find { Users.email eq email }.singleOrNull()
		if (caller != null && caller.association != user?.association && caller.scope != 2) {
			null
		} else {
			user
		}
	}

	fun getUserByUsername(caller: User?, username: String): User? = transaction(db) {
		val user = User.find { Users.username eq username }.singleOrNull()
		if (caller != null && caller.association != user?.association && caller.scope != 2) {
			null
		} else {
			user
		}
	}
}