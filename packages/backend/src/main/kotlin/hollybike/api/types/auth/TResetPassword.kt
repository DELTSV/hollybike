/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.types.auth

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class TResetPassword(
	@SerialName("new_password")
	val newPassword: String,
	@SerialName("new_password_confirmation")
	val newPasswordConfirmation: String,
	val expire: Long,
	val token: String
)
