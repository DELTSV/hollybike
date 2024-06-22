package hollybike.api.types.user

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class TUserUpdateSelf(
	val username: String? =  null,
	@SerialName("new_password")
	val newPassword: String? =  null,
	@SerialName("new_password_again")
	val newPasswordAgain: String? =  null,
	@SerialName("old_password")
	val oldPassword: String? =  null,
	val role: String? = null
)
