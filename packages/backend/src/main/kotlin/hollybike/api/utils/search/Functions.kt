package hollybike.api.utils.search

import hollybike.api.repository.lower
import hollybike.api.repository.unaccent
import io.ktor.http.*
import kotlinx.datetime.Instant
import kotlinx.datetime.LocalDate
import kotlinx.datetime.TimeZone
import kotlinx.datetime.atStartOfDayIn
import org.jetbrains.exposed.sql.*
import org.jetbrains.exposed.sql.SqlExpressionBuilder.eq
import org.jetbrains.exposed.sql.SqlExpressionBuilder.greater
import org.jetbrains.exposed.sql.SqlExpressionBuilder.greaterEq
import org.jetbrains.exposed.sql.SqlExpressionBuilder.less
import org.jetbrains.exposed.sql.SqlExpressionBuilder.lessEq
import org.jetbrains.exposed.sql.SqlExpressionBuilder.like
import org.jetbrains.exposed.sql.SqlExpressionBuilder.neq
import org.jetbrains.exposed.sql.kotlin.datetime.KotlinInstantColumnType

fun Parameters.getSearchParam(mapper: Mapper): SearchParam {
	val page = get("page")?.toIntOrNull() ?: 0
	val perPage = get("per_page")?.toIntOrNull() ?: 20
	val query = get("query")
	val sort = getAll("sort")?.map {
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
	}?.filterNotNull() ?: emptyList()
	val filter = mapper.asSequence().filter { (k, _) -> k in this }
		.map { (k, v) ->
			getAll(k)!!.map {
				val (mode, value) = it.split(":", limit = 2)
				if (mode !in FilterMode) {
					null
				} else {
					Filter(v, value, FilterMode[mode])
				}
			}
		}.flatten().filterNotNull().toMutableList()
	return SearchParam(
		query,
		sort,
		filter,
		page,
		perPage
	)
}

fun Query.applyParam(searchParam: SearchParam): Query {
	var q = this
	q = q.orderBy(*searchParam.sort.map { (c, o) -> c to o }.toTypedArray())
	q = q.limit(searchParam.perPage, searchParam.page * searchParam.perPage.toLong())
	val filter = searchParamFilter(searchParam.filter)
	val query = searchParam.query?.let { query -> q.searchParamQuery(query) }
	val where = if(query == null) {
		filter
	} else {
		if(filter == null) {
			query
		} else {
			query and filter
		}
	}
	return where?.let { q.where(where) } ?: q
}

private fun Query.searchParamQuery(query: String): Op<Boolean>? {
	var op: Op<Boolean>? = null
	this.targets.forEach { table ->
		table.columns.forEach { col ->
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
	}
	return op
}

private fun searchParamFilter(filter: List<Filter>): Op<Boolean>? = filter
	.mapNotNull {
		it.column
		when (it.mode) {
			FilterMode.EQUAL -> it.column equal it.value
			FilterMode.NOT_EQUAL -> it.column nEqual it.value
			FilterMode.LOWER_THAN -> it.column lt it.value
			FilterMode.GREATER_THAN -> it.column gt it.value
			FilterMode.LESS_THAN_EQUAL -> it.column lte it.value
			FilterMode.GREATER_THAN_EQUAL -> it.column gte it.value
		}
	}.reduceOrNull { acc, v ->
		acc and v
	}

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

		else -> null
	}

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

		else -> null
	}

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

		else -> null
	}

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

		else -> null
	}

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

		else -> null
	}

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

		else -> null
	}

fun Mapper.getMapperData(): Map<String, String> = this.mapValues {
	when(it.value.columnType) {
		is VarCharColumnType -> "String"
		is IntegerColumnType -> "Int"
		is KotlinInstantColumnType -> "DateTime"
		is EntityIDColumnType<*> -> "Int (id)"
		else -> "Unknown"
	}
}