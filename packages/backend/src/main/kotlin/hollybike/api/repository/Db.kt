package hollybike.api.repository

import hollybike.api.conf
import hollybike.api.isCloud
import io.ktor.server.application.*
import liquibase.UpdateSummaryEnum
import liquibase.command.CommandScope
import liquibase.command.core.UpdateCommandStep
import liquibase.command.core.helpers.DbUrlConnectionArgumentsCommandStep
import liquibase.command.core.helpers.ShowSummaryArgument
import liquibase.database.DatabaseFactory
import liquibase.database.jvm.JdbcConnection
import org.jetbrains.exposed.sql.Database
import org.jetbrains.exposed.sql.DatabaseConfig
import java.sql.Connection

fun Application.configureDatabase(): Database {
	log.info("Configuring Database")
	val conf = attributes.conf

	return Database.connect(
		url = conf.db.url,
		user = conf.db.username,
		password = conf.db.password,
		driver = "org.postgresql.Driver",
		databaseConfig = DatabaseConfig {
			keepLoadedReferencesOutOfTransaction = true
		}).apply {
		runMigration(developmentMode, isCloud, this.connector().connection as Connection)
	}
}

fun runMigration(isDev: Boolean, isCloud: Boolean, connection: Connection) {
	val changelog = "/liquibase-changelog.sql"
	val context = (if (isDev) "dev," else "") + (if (isCloud) "cloud" else "premise")

	val db = DatabaseFactory.getInstance().findCorrectDatabaseImplementation(JdbcConnection(connection))
	CommandScope("update").apply {
		addArgumentValue(UpdateCommandStep.CHANGELOG_FILE_ARG, changelog)
		addArgumentValue(DbUrlConnectionArgumentsCommandStep.DATABASE_ARG, db)
		addArgumentValue(UpdateCommandStep.CONTEXTS_ARG, context)
		addArgumentValue(ShowSummaryArgument.SHOW_SUMMARY, UpdateSummaryEnum.OFF)
	}.execute()
}