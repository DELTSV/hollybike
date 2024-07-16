/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.types.association

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class TOnboardingUpdate(
	@SerialName("update_default_user")
	val updateDefaultUser: Boolean? = null,
	@SerialName("update_association")
	val updateAssociation: Boolean? = null,
	@SerialName("create_invitation")
	val createInvitation: Boolean? = null
)