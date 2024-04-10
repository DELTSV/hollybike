package hollybike.api.repository

import hollybike.api.conf
import io.ktor.server.application.*
import org.ktorm.database.Database
import org.ktorm.support.postgresql.PostgreSqlDialect

fun Application.configureDatabase(): Database {
	val conf = attributes.conf
	return Database.connect(conf.db.url, user = conf.db.username, password = conf.db.password, dialect = PostgreSqlDialect())
}