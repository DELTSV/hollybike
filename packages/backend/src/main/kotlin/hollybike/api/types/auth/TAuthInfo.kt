package hollybike.api.types.auth

import kotlinx.serialization.Serializable

@Serializable
data class TAuthInfo(
	val token: String
)
