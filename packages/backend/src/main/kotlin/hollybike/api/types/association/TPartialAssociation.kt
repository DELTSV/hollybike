package hollybike.api.types.association

import hollybike.api.repository.Association
import kotlinx.serialization.Serializable

@Serializable
data class TPartialAssociation(
	val id: Int,
	val name: String,
	val picture: String? = null
) {
	constructor(entity: Association, signer: (String) -> String) : this(
		entity.id.value,
		entity.name,
		entity.picture?.let { signer(it) }
	)
}
