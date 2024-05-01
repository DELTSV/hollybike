package hollybike.api.config

import com.trendol.stove.testing.e2e.rdbms.postgres.PostgresqlOptions
import com.trendol.stove.testing.e2e.rdbms.postgres.postgresql
import com.trendyol.stove.testing.e2e.http.httpClient
import com.trendyol.stove.testing.e2e.ktor
import com.trendyol.stove.testing.e2e.system.TestSystem
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
							"database.host=${cfg.host}",
							"database.port=${cfg.port}",
							"database.name=${cfg.database}",
							"database.username=${cfg.username}",
							"database.password=${cfg.password}"
						)
					})
				}
				ktor(
					withParameters = listOf(
						"port=8080",
					),
					runner = {
						hollybike.api.run(isTestEnv = true)
					}
				)
			}.run()

	override suspend fun afterProject() {
		TestSystem.stop()
	}
}