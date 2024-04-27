package hollybike.api.types.auth

import kotlinx.serialization.Serializable

@Serializable
data class TSignin(
	val email: String,
	val password: String,
	val username: String,
	val verify: String,
	val association: Int? = null,
	val role: Int
)
