package hollybike.api.repository

import hollybike.api.database.now
import hollybike.api.repository.Invitations.defaultExpression
import kotlinx.datetime.Clock
import org.jetbrains.exposed.dao.IntEntity
import org.jetbrains.exposed.dao.IntEntityClass
import org.jetbrains.exposed.dao.id.EntityID
import org.jetbrains.exposed.dao.id.IntIdTable
import org.jetbrains.exposed.sql.kotlin.datetime.timestamp

object Tokens: IntIdTable("tokens", "id_token") {
	val token = varchar("token", 35)
	val user = reference("user", Users)
	val device = varchar("device", 40)
	val lastUse = timestamp("last_use").defaultExpression(now())
}

class Token(id: EntityID<Int>) : IntEntity(id) {
	var token by Tokens.token
	var user by User referencedOn Tokens.user
	var device by Tokens.device
	val lastUser by Tokens.lastUse

	companion object: IntEntityClass<Token>(Tokens)
}