/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.utils.search

import org.jetbrains.exposed.sql.Column
import org.jetbrains.exposed.sql.SortOrder

data class SearchParam(
	val query: String?,
	val sort: List<Sort>,
	val filter: MutableList<Filter>,
	val page: Int,
	var perPage: Int,
	val mapper: Mapper
)

data class Filter(
	val column: Column<out Any?>,
	val value: String?,
	val mode: FilterMode
)

data class Sort(
	val column: Column<out Any?>,
	val order: SortOrder
)

enum class FilterMode(val mode: String) {
	EQUAL("eq"),
	NOT_EQUAL("neq"),
	LOWER_THAN("lt"),
	GREATER_THAN("gt"),
	LESS_THAN_EQUAL("lte"),
	GREATER_THAN_EQUAL("gte"),
	IS_NULL("isnull"),
	IS_NOT_NULL("isnotnull");

	companion object {
		operator fun get(mode: String): FilterMode = entries.find { it.mode == mode }!!

		operator fun contains(mode: String): Boolean = entries.find { it.mode == mode } != null
	}
}

typealias Mapper = Map<String, Column<out Any?>>