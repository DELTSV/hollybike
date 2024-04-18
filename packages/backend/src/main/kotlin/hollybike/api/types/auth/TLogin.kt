package hollybike.api.types.auth

import kotlinx.serialization.Serializable

@Serializable
data class TLogin(
	val email: String,
	val password: String
)