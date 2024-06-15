package hollybike.api.types.position

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class TPlaceResponse(
	val category: String,
	val type: String,
	@SerialName("addresstype") val addressType: String,
	val name: String,
	val address: Address,
) {
	@Serializable
	data class Address(
		val city: String? = null,
		val town: String? = null,
		val village: String? = null,
		val hamlet: String? = null,
		val suburb: String? = null,
		val municipality: String? = null,
		val county: String? = null,
		val state: String? = null,
		val region: String? = null,
		val country: String,
	)
}