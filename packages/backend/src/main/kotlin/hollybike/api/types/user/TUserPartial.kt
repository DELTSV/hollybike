package hollybike.api.types.user

import hollybike.api.repository.User
import hollybike.api.types.event.EEventRole
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
	@SerialName("event_role")
	val eventRole: EEventRole? = null,
	@SerialName("is_owner")
	val isOwner: Boolean? = null
) {
	constructor(entity: User) : this(
		id = entity.id.value,
		username = entity.username,
		scope = entity.scope,
		status = entity.status,
		profilePicture = entity.profilePicture
	)

	constructor(entity: User, isOwner: Boolean, eventRole: EEventRole?) : this(
		id = entity.id.value,
		username = entity.username,
		scope = entity.scope,
		status = entity.status,
		profilePicture = entity.profilePicture,
		eventRole = eventRole,
		isOwner = isOwner
	)
}
