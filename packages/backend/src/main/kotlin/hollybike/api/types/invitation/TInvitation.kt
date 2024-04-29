package hollybike.api.types.invitation

import hollybike.api.types.user.EUserScope
import hollybike.api.types.user.TUser
import kotlinx.datetime.Instant

data class TInvitation(
	val id: Int,
	val role: EUserScope,
	val status: EInvitationStatus,
	val creator: TUser,
	val expiration: Instant,
	val creation: Instant,
	val uses: Int,
	val maxUses: Int,
	val link: String
)