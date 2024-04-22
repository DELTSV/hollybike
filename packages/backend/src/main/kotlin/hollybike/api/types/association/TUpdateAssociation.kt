package hollybike.api.types.association

import kotlinx.serialization.Serializable

@Serializable
data class TUpdateAssociation(
	val name: String? = null,
	val status: EAssociationsStatus? = null
)
