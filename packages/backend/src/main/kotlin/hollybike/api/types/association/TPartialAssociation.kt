/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.types.association

import hollybike.api.repository.Association
import kotlinx.serialization.Serializable

@Serializable
data class TPartialAssociation(
	val id: Int,
	val name: String,
	val picture: String? = null
) {
	constructor(entity: Association) : this(
		entity.id.value,
		entity.name,
		entity.signedPicture
	)
}
