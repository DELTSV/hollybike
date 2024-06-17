package hollybike.api.utils.search

import hollybike.api.database.lower
import hollybike.api.database.unaccent
import io.ktor.http.*
import kotlinx.datetime.Instant
import kotlinx.datetime.LocalDate
import kotlinx.datetime.TimeZone
import kotlinx.datetime.atStartOfDayIn
import org.jetbrains.exposed.sql.*
import org.jetbrains.exposed.sql.SqlExpressionBuilder.eq
import org.jetbrains.exposed.sql.SqlExpressionBuilder.greater
import org.jetbrains.exposed.sql.SqlExpressionBuilder.greaterEq
import org.jetbrains.exposed.sql.SqlExpressionBuilder.isNotNull
import org.jetbrains.exposed.sql.SqlExpressionBuilder.isNull
import org.jetbrains.exposed.sql.SqlExpressionBuilder.less
import org.jetbrains.exposed.sql.SqlExpressionBuilder.lessEq
import org.jetbrains.exposed.sql.SqlExpressionBuilder.like
import org.jetbrains.exposed.sql.SqlExpressionBuilder.neq
import org.jetbrains.exposed.sql.kotlin.datetime.KotlinInstantColumnType

fun Parameters.getSearchParam(mapper: Mapper): SearchParam {
	val page = get("page")?.toIntOrNull() ?: 0
	val perPage = get("per_page")?.toIntOrNull() ?: 20
	val query = get("query")
	val sort = getAll("sort")?.mapNotNull {
		val (col, sort) = it.split(".")
		if (col in mapper.keys) {
			if (sort.uppercase() == "ASC") {
				Sort(mapper[col]!!, SortOrder.ASC)
			} else if (sort.uppercase() == "DESC") {
				Sort(mapper[col]!!, SortOrder.DESC)
			} else {
				null
			}
		} else {
			null
		}
	} ?: emptyList()
	val filter = mapper.asSequence().filter { (k, _) -> k in this }
		.map { (k, v) ->
			getAll(k)!!.map allMap@{
				val (mode, value) = if (':' in it) {
					it.split(":", limit = 2).let { values -> values[0] to values[1] }
				} else {
					it to null
				}
				if (mode !in FilterMode) {
					null
				} else {
					val filterMode = FilterMode[mode]
					if (value == null && filterMode != FilterMode.IS_NULL && filterMode != FilterMode.IS_NOT_NULL) {
						null
					} else {
						Filter(v, value, FilterMode[mode])
					}
				}
			}
		}.flatten().filterNotNull().toMutableList()
	return SearchParam(
		query,
		sort,
		filter,
		page,
		perPage,
		mapper
	)
}

fun Query.applyParam(searchParam: SearchParam, pagination: Boolean = true): Query {
	var q = this
	q = q.orderBy(*searchParam.sort.map { (c, o) -> c to o }.toTypedArray())
	if (pagination) {
		q = q.limit(searchParam.perPage, searchParam.page * searchParam.perPage.toLong())
	}
	val filter = searchParamFilter(searchParam.filter)
	println(filter)
	println(searchParam.filter)
	val query = if ((searchParam.query?.split(" ")?.size ?: 0) == 2) {
		val values = searchParam.query!!.split(" ")
		val val1 = q.searchParamQuery(values.joinToString("%") { it.replace("%", "\\%") }, searchParam.mapper)
		val val2 = q.searchParamQuery(values.reversed().joinToString("%") { it.replace("%", "\\%") }, searchParam.mapper)
		if (val1 != null) {
			if (val2 != null) {
				val1 or val2
			} else {
				val1
			}
		} else {
			val2
		}
	} else {
		searchParam.query?.let { query -> q.searchParamQuery(query.replace("%", "\\%").replace(" ", "%"), searchParam.mapper) }
	}
	val where = if (query == null) {
		filter
	} else {
		if (filter == null) {
			query
		} else {
			query and filter
		}
	}
	return where?.let { q.where(where) } ?: q
}

@Suppress("UNCHECKED_CAST")
private fun Query.searchParamQuery(query: String, mapper: Mapper): Op<Boolean>? {
	var op: Op<Boolean>? = null
	mapper.forEach { (_, col) ->
		when (col.columnType) {
			is IntegerColumnType -> {
				query.toIntOrNull()?.let {
					op = op?.or((col as Column<Int?>) eq it) ?: ((col as Column<Int?>) eq it)
				}
			}

			is VarCharColumnType -> {
				op =
					op?.or(lower(unaccent(col as Column<String>)) like lower(unaccent("%$query%"))) ?: (lower(
						unaccent((col as Column<String>))
					) like lower(unaccent("%$query%")))
			}
		}
	}
	return op
}

private fun searchParamFilter(filter: List<Filter>): Op<Boolean>? = filter
	.mapNotNull {
		when (it.mode) {
			FilterMode.EQUAL -> it.column equal it.value!!
			FilterMode.NOT_EQUAL -> it.column nEqual it.value!!
			FilterMode.LOWER_THAN -> it.column lt it.value!!
			FilterMode.GREATER_THAN -> it.column gt it.value!!
			FilterMode.LESS_THAN_EQUAL -> it.column lte it.value!!
			FilterMode.GREATER_THAN_EQUAL -> it.column gte it.value!!
			FilterMode.IS_NULL -> it.column.isNull()
			FilterMode.IS_NOT_NULL -> it.column.isNotNull()
		}
	}.reduceOrNull { acc, v ->
		acc and v
	}

@Suppress("UNCHECKED_CAST")
private infix fun Column<out Any?>.equal(value: String): Op<Boolean>? =
	when (columnType) {
		is IntegerColumnType -> value.toIntOrNull()?.let { (this as Column<Int?>) eq it }
		is VarCharColumnType -> (this as Column<String?>) eq value
		is KotlinInstantColumnType -> try {
			Instant.parse(value)
		} catch (e: IllegalArgumentException) {
			try {
				LocalDate.parse(value).atStartOfDayIn(TimeZone.UTC)
			} catch (_: Exception) {
				null
			}
		}?.let { (this as Column<Instant?>) eq it }

		is EntityIDColumnType<*> -> {
			if (columnType.sqlType() == "INT" || columnType.sqlType() == "SERIAL") {
				value.toIntOrNull()?.let { (this as Column<Int?>) eq it }
			} else {
				null
			}
		}

		else -> null
	}

@Suppress("UNCHECKED_CAST")
private infix fun Column<out Any?>.nEqual(value: String): Op<Boolean>? =
	when (columnType) {
		is IntegerColumnType -> value.toIntOrNull()?.let { (this as Column<Int?>) neq it }
		is VarCharColumnType -> (this as Column<String?>) neq value
		is KotlinInstantColumnType -> try {
			Instant.parse(value)
		} catch (e: IllegalArgumentException) {
			try {
				LocalDate.parse(value).atStartOfDayIn(TimeZone.UTC)
			} catch (_: Exception) {
				null
			}
		}?.let { (this as Column<Instant?>) neq it }

		is EntityIDColumnType<*> -> {
			if (columnType.sqlType() == "INT" || columnType.sqlType() == "SERIAL") {
				value.toIntOrNull()?.let { (this as Column<Int?>) neq it }
			} else {
				null
			}
		}

		else -> null
	}

@Suppress("UNCHECKED_CAST")
private infix fun Column<out Any?>.lt(value: String): Op<Boolean>? =
	when (columnType) {
		is IntegerColumnType -> value.toIntOrNull()?.let { (this as Column<Int?>) less it }
		is VarCharColumnType -> (this as Column<String?>) less value
		is KotlinInstantColumnType -> try {
			Instant.parse(value)
		} catch (e: IllegalArgumentException) {
			try {
				LocalDate.parse(value).atStartOfDayIn(TimeZone.UTC)
			} catch (_: Exception) {
				null
			}
		}?.let { (this as Column<Instant?>) less it }

		is EntityIDColumnType<*> -> {
			if (columnType.sqlType() == "INT" || columnType.sqlType() == "SERIAL") {
				value.toIntOrNull()?.let { (this as Column<Int?>) less it }
			} else {
				null
			}
		}

		else -> null
	}

@Suppress("UNCHECKED_CAST")
private infix fun Column<out Any?>.gt(value: String): Op<Boolean>? =
	when (columnType) {
		is IntegerColumnType -> value.toIntOrNull()?.let { (this as Column<Int?>) greater it }
		is VarCharColumnType -> (this as Column<String?>) greater value
		is KotlinInstantColumnType -> try {
			Instant.parse(value)
		} catch (e: IllegalArgumentException) {
			try {
				LocalDate.parse(value).atStartOfDayIn(TimeZone.UTC)
			} catch (_: Exception) {
				null
			}
		}?.let { (this as Column<Instant?>) greater it }

		is EntityIDColumnType<*> -> {
			if (columnType.sqlType() == "INT" || columnType.sqlType() == "SERIAL") {
				value.toIntOrNull()?.let { (this as Column<Int?>) greater it }
			} else {
				null
			}
		}

		else -> null
	}

@Suppress("UNCHECKED_CAST")
private infix fun Column<out Any?>.lte(value: String): Op<Boolean>? =
	when (columnType) {
		is IntegerColumnType -> value.toIntOrNull()?.let { (this as Column<Int?>) lessEq it }
		is VarCharColumnType -> (this as Column<String?>) lessEq value
		is KotlinInstantColumnType -> try {
			Instant.parse(value)
		} catch (e: IllegalArgumentException) {
			try {
				LocalDate.parse(value).atStartOfDayIn(TimeZone.UTC)
			} catch (_: Exception) {
				null
			}
		}?.let { (this as Column<Instant?>) lessEq it }

		is EntityIDColumnType<*> -> {
			if (columnType.sqlType() == "INT" || columnType.sqlType() == "SERIAL") {
				value.toIntOrNull()?.let { (this as Column<Int?>) lessEq it }
			} else {
				null
			}
		}

		else -> null
	}

@Suppress("UNCHECKED_CAST")
private infix fun Column<out Any?>.gte(value: String): Op<Boolean>? =
	when (columnType) {
		is IntegerColumnType -> value.toIntOrNull()?.let { (this as Column<Int?>) greaterEq it }
		is VarCharColumnType -> (this as Column<String?>) greaterEq value
		is KotlinInstantColumnType -> try {
			Instant.parse(value)
		} catch (e: IllegalArgumentException) {
			try {
				LocalDate.parse(value).atStartOfDayIn(TimeZone.UTC)
			} catch (_: Exception) {
				null
			}
		}?.let { (this as Column<Instant?>) greaterEq it }

		is EntityIDColumnType<*> -> {
			if (columnType.sqlType() == "INT" || columnType.sqlType() == "SERIAL") {
				value.toIntOrNull()?.let { (this as Column<Int?>) greaterEq it }
			} else {
				null
			}
		}

		else -> null
	}

fun Mapper.getMapperData(): Map<String, String> = this.mapValues {
	when (it.value.columnType) {
		is VarCharColumnType -> "String"
		is IntegerColumnType -> "Int"
		is KotlinInstantColumnType -> "DateTime"
		is EntityIDColumnType<*> -> "Int (id)"
		else -> "Unknown"
	}
}