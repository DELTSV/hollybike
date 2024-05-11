import hollybike.api.repository.User
import hollybike.api.types.user.EUserScope
import hollybike.api.types.user.EUserStatus
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class TUserPartial(
	val id: Int,
	val username: String,
	val scope: EUserScope,
	val status: EUserStatus,
	@SerialName("profile_picture")
	val profilePicture: String? = null,
) {
	constructor(entity: User): this(
		id = entity.id.value,
		username = entity.username,
		scope = entity.scope,
		status = entity.status,
		profilePicture = entity.profilePicture
	)
}
