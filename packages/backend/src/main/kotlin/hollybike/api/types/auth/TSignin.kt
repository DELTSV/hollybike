package hollybike.api.types.auth

import kotlinx.serialization.Serializable

@Serializable
data class TSignin(
	val email: String,
	val password: String
)
