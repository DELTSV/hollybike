package hollybike.api.repository

import org.jetbrains.exposed.sql.*

fun lower(string: String) = object: ExpressionWithColumnType<String>() {
	override val columnType: IColumnType
		get() = VarCharColumnType()

	override fun toQueryBuilder(queryBuilder: QueryBuilder) {
		queryBuilder.append("LOWER('", string.replace("'", "\'") ,"')")
		TODO("Not yet implemented")
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