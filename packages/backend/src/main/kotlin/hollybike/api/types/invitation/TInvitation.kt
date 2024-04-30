package hollybike.api.types.invitation

import hollybike.api.repository.Invitation
import hollybike.api.types.user.EUserScope
import kotlinx.datetime.Instant
import kotlinx.serialization.Serializable

@Serializable
data class TInvitation(
	val id: Int,
	val role: EUserScope,
	val status: EInvitationStatus,
	val expiration: Instant?,
	val creation: Instant,
	val uses: Int,
	val maxUses: Int?,
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
		link
	)
}