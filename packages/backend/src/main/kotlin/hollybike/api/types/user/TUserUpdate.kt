package hollybike.api.types.user

import kotlinx.serialization.Serializable

@Serializable
data class TUserUpdate(
	val username: String? = null,
	val email: String? = null,
	val password: String? = null,
	val status: EUserStatus? = null,
	val scope: EUserScope? = null,
	val association: Int? = null
)
