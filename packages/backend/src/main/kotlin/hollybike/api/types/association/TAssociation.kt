package hollybike.api.types.association

import hollybike.api.repository.Association
import kotlinx.serialization.Serializable

@Serializable
data class TAssociation(
	val id: Int,
	val name: String
) {
	constructor(entity: Association): this(
		entity.id.value,
		entity.name
	)
}
