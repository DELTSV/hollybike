package hollybike.api.database

import kotlinx.datetime.Instant
import org.jetbrains.exposed.sql.*
import kotlin.time.Duration

fun lower(string: String) = object: ExpressionWithColumnType<String>() {
	override val columnType: IColumnType
		get() = VarCharColumnType()

	override fun toQueryBuilder(queryBuilder: QueryBuilder) {
		queryBuilder.append("LOWER('", string.replace("'", "\'") ,"')")
	}

}

fun lower(expr: Expression<String>) = object: ExpressionWithColumnType<String>() {
	override val columnType: IColumnType
		get() = VarCharColumnType()

	override fun toQueryBuilder(queryBuilder: QueryBuilder) {
		queryBuilder.append("LOWER(", expr, ")")
	}
}

fun unaccent(string: String) = object: ExpressionWithColumnType<String>() {
	override val columnType: IColumnType
		get() = VarCharColumnType()

	override fun toQueryBuilder(queryBuilder: QueryBuilder) {
		queryBuilder.append("UNACCENT('", string.replace("'", "\'") ,"')")
	}
}

fun unaccent(expr: Expression<String>) = object: ExpressionWithColumnType<String>() {
	override val columnType: IColumnType
		get() = VarCharColumnType()

	override fun toQueryBuilder(queryBuilder: QueryBuilder) {
		queryBuilder.append("UNACCENT(", expr, ")")
	}
}

private fun toInterval(time: Duration): String = "INTERVAL '${time.inWholeSeconds.toInt()}' second"

fun addtime(expr: Expression<Instant>, time: Duration) = object: Expression<Instant?>() {
	override fun toQueryBuilder(queryBuilder: QueryBuilder) {
		queryBuilder.append(expr, " + ", toInterval(time))
	}
}

fun subtime(expr: Expression<Instant>, time: Duration) = object: Expression<Instant>() {
	override fun toQueryBuilder(queryBuilder: QueryBuilder) {
		queryBuilder.append(expr, " - ", toInterval(time))
	}
}

fun now() = object : Expression<Instant>() {
	override fun toQueryBuilder(queryBuilder: QueryBuilder) {
		queryBuilder.append("NOW()")
	}
}