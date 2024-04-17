package hollybike.api.repository

import hollybike.api.conf
import io.ktor.server.application.*
import liquibase.command.CommandScope
import liquibase.command.core.UpdateCommandStep
import liquibase.command.core.helpers.DbUrlConnectionArgumentsCommandStep
import liquibase.database.DatabaseFactory
import liquibase.database.jvm.JdbcConnection
import org.ktorm.database.Database
import org.ktorm.support.postgresql.PostgreSqlDialect

fun Application.configureDatabase(): Database {
	val conf = attributes.conf
	return Database.connect(conf.db.url, user = conf.db.username, password = conf.db.password, dialect = PostgreSqlDialect()).apply {
		runMigration()
	}
}

fun Database.runMigration() {
	val changelog = "/liquibase-changelog.sql"
	this.useConnection {
		val db = DatabaseFactory.getInstance().findCorrectDatabaseImplementation(JdbcConnection(it))
		CommandScope("update").apply {
			addArgumentValue(UpdateCommandStep.CHANGELOG_FILE_ARG, changelog)
			addArgumentValue(DbUrlConnectionArgumentsCommandStep.DATABASE_ARG, db)
		}.execute()
	}
}