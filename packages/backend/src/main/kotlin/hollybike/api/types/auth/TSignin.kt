package hollybike.api.types.auth

import hollybike.api.types.user.EUserScope
import kotlinx.serialization.Serializable

@Serializable
data class TSignin(
	val email: String,
	val password: String,
	val username: String,
	val verify: String,
	val association: Int,
	val role: EUserScope,
	val invitation: Int
)
