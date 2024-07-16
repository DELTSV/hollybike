/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.types.user

import hollybike.api.repository.User
import hollybike.api.types.association.TAssociation
import kotlinx.datetime.Instant
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class TUser(
	val id: Int,
	val email: String,
	val username: String,
	val scope: EUserScope,
	val status: EUserStatus,
	@SerialName("last_login")
	val lastLogin: Instant,
	val association: TAssociation,
	@SerialName("profile_picture")
	val profilePicture: String? = null,
	@SerialName("profile_picture_key")
	val profilePictureKey: String? = null,
	val role: String? = null
) {
	constructor(entity: User) : this(
		id = entity.id.value,
		email = entity.email,
		username = entity.username,
		scope = entity.scope,
		status = entity.status,
		lastLogin = entity.lastLogin,
		association = TAssociation(entity.association),
		profilePicture = entity.signedProfilePicture,
		profilePictureKey = entity.profilePicture,
		role = entity.role
	)
}
