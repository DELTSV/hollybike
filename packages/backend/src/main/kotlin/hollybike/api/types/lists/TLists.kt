package hollybike.api.types.lists

import hollybike.api.utils.search.SearchParam
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import kotlin.math.ceil

@Serializable
data class TLists<T>(
	val data: List<T>,
	val page: Int,
	@SerialName("total_page")
	val totalPage: Int,
	@SerialName("per_page")
	val perPage: Int,
	@SerialName("total_data")
	val totalData: Long
) {
	constructor(data: List<T>, param: SearchParam, total: Long): this (
		data,
		param.page,
		ceil(total.div(param.perPage.toDouble())).toInt(),
		param.perPage,
		total
	)
}
