package hollybike.api.types.association

import hollybike.api.repository.Association
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class TOnboarding(
	@SerialName("update_default_user")
	val updateDefaultUser: Boolean,
	@SerialName("update_association")
	val updateAssociation: Boolean,
	@SerialName("create_invitation")
	val createInvitation: Boolean
) {
	constructor(associations: Association): this(
		associations.updateDefaultUser,
		associations.updateAssociation,
		associations.createInvitation
	)
}
