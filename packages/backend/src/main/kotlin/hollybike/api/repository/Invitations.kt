package hollybike.api.repository

import hollybike.api.database.now
import hollybike.api.types.invitation.EInvitationStatus
import hollybike.api.types.user.EUserScope
import hollybike.api.utils.search.Mapper
import kotlinx.datetime.Clock
import org.jetbrains.exposed.dao.IntEntity
import org.jetbrains.exposed.dao.IntEntityClass
import org.jetbrains.exposed.dao.id.EntityID
import org.jetbrains.exposed.dao.id.IntIdTable
import org.jetbrains.exposed.sql.kotlin.datetime.timestamp

object Invitations: IntIdTable("invitations", "id_invitation") {
	val role = integer("role")
	val status = integer("status").default(1)
	val association = reference("association", Associations)
	val creator = reference("creator", Users)
	val expiration = timestamp("expiration").nullable()
	val creation = timestamp("creation").defaultExpression(now())
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
	var maxUses by Invitations.maxUses

	companion object: IntEntityClass<Invitation>(Invitations)
}

val invitationMapper: Mapper = mapOf(
	"role" to Invitations.role,
	"status" to Invitations.status,
	"association" to Invitations.association,
	"creator" to Invitations.creator,
	"expiration" to Invitations.expiration,
	"uses" to Invitations.uses,
	"max_uses" to Invitations.maxUses,
)