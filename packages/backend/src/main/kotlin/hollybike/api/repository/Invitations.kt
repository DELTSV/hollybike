package hollybike.api.repository

import hollybike.api.types.invation.EInvitationStatus
import hollybike.api.types.user.EUserScope
import kotlinx.datetime.Clock
import org.jetbrains.exposed.dao.IntEntity
import org.jetbrains.exposed.dao.IntEntityClass
import org.jetbrains.exposed.dao.id.EntityID
import org.jetbrains.exposed.dao.id.IntIdTable
import org.jetbrains.exposed.sql.kotlin.datetime.timestamp

object Invitations: IntIdTable("invitations", "id_invitation") {
	val role = integer("role")
	val status = integer("status").default(1)
	val association = integer("association")
	val creator = integer("creator")
	val expiration = timestamp("expiration").nullable()
	val creation = timestamp("creation").default(Clock.System.now())
	val uses = integer("uses").default(0)
	val maxUses = integer("max_uses").nullable().default(null)
}

class Invitation(id: EntityID<Int>) : IntEntity(id) {
	var role by Invitations.role.transform({ it.value }, { EUserScope[it] })
	var status by Invitations.status.transform({ it.value }, { EInvitationStatus[it] })
	var association by Association referencedOn Invitations.association
	var creator by User referencedOn Invitations.creator
	var expiration by Invitations.expiration
	var creation by Invitations.creation
	var uses by Invitations.uses
	val maxUses by Invitations.maxUses

	companion object: IntEntityClass<Invitation>(Invitations)
}