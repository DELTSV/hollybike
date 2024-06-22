package hollybike.api.types.auth

import kotlinx.serialization.Serializable

@Serializable
data class TRefresh(
	val device: String,
	val token: String
)
