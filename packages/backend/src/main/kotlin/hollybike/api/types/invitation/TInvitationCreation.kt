package hollybike.api.types.invitation

import hollybike.api.types.user.EUserScope
import kotlinx.datetime.Instant
import kotlinx.serialization.Serializable

@Serializable
data class TInvitationCreation(
	val label: String? = null,
	val role: EUserScope,
	val association: Int? = null,
	val maxUses: Int? = null,
	val expiration: Instant? = null
)
