package hollybike.api.types.invitation

import hollybike.api.repository.Invitation
import hollybike.api.types.association.TAssociation
import hollybike.api.types.user.EUserScope
import kotlinx.datetime.Instant
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class TInvitation(
	val id: Int,
	val role: EUserScope,
	val status: EInvitationStatus,
	val expiration: Instant?,
	val creation: Instant,
	val uses: Int,
	@SerialName("max_uses")
	val maxUses: Int?,
	val association: TAssociation,
	val link: String? = null
) {
	constructor(invitation: Invitation, link: String? = null) : this(
		invitation.id.value,
		invitation.role,
		invitation.status,
		invitation.expiration,
		invitation.creation,
		invitation.uses,
		invitation.maxUses,
		TAssociation(invitation.association),
		link
	)
}