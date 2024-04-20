package hollybike.api.repository

import kotlinx.datetime.Instant
import kotlinx.datetime.toJavaInstant
import kotlinx.datetime.toKotlinInstant
import org.ktorm.schema.BaseTable
import org.ktorm.schema.Column
import org.ktorm.schema.SqlType
import java.sql.PreparedStatement
import java.sql.ResultSet
import java.sql.Timestamp
import java.sql.Types

fun BaseTable<*>.datetime(name: String): Column<Instant> {
	return registerColumn(name, InstantDateTimeSqlType)
}

object InstantDateTimeSqlType : SqlType<Instant>(Types.TIMESTAMP, "datetime") {

	override fun doSetParameter(ps: PreparedStatement, index: Int, parameter: Instant) {
		ps.setTimestamp(index, Timestamp.from(parameter.toJavaInstant()))
	}

	override fun doGetResult(rs: ResultSet, index: Int): Instant? {
		return rs.getTimestamp(index)?.toInstant()?.toKotlinInstant()
	}
}