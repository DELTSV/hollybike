package hollybike.api.types.lists

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class TLists<T>(
	val data: List<T>,
	val page: Int,
	@SerialName("total_page")
	val totalPage: Int,
	@SerialName("per_page")
	val perPage: Int,
	@SerialName("total_data")
	val totalData: Int
)
