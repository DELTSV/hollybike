package hollybike.api.config

import com.trendol.stove.testing.e2e.rdbms.postgres.PostgresqlOptions
import com.trendol.stove.testing.e2e.rdbms.postgres.postgresql
import com.trendyol.stove.testing.e2e.http.httpClient
import com.trendyol.stove.testing.e2e.ktor
import com.trendyol.stove.testing.e2e.system.TestSystem
import hollybike.api.TestDatabaseConfig
import io.kotest.core.config.AbstractProjectConfig

class TestSystemConfig : AbstractProjectConfig() {
	override suspend fun beforeProject() =
		TestSystem(baseUrl = "http://localhost:8080")
			.with {
				httpClient()
//				bridge()
				postgresql {
					PostgresqlOptions(configureExposedConfiguration = { cfg ->
						listOf(
							"database.jdbcUrl=${cfg.jdbcUrl}",
							"database.username=${cfg.username}",
							"database.password=${cfg.password}"
						)
					})
				}
				ktor(
					withParameters = listOf(
						"port=8080",
					),
					runner = { parameters ->
						val dbUrl = parameters.firstOrNull { it.startsWith("database.jdbcUrl") }?.substringAfter("=")
						val dbUser = parameters.firstOrNull { it.startsWith("database.username") }?.substringAfter("=")
						val dbPass = parameters.firstOrNull { it.startsWith("database.password") }?.substringAfter("=")
						hollybike.api.run(
							isTestEnv = true,
							testDatabaseConfig = TestDatabaseConfig(dbUrl!!, dbUser!!, dbPass!!)
						)
					}
				)
			}.run()

	override suspend fun afterProject() {
		TestSystem.stop()
	}
}