package hollybike.api.config

import com.trendol.stove.testing.e2e.rdbms.postgres.PostgresqlOptions
import com.trendol.stove.testing.e2e.rdbms.postgres.postgresql
import com.trendyol.stove.testing.e2e.http.httpClient
import com.trendyol.stove.testing.e2e.ktor
import com.trendyol.stove.testing.e2e.system.TestSystem
import io.kotest.core.config.AbstractProjectConfig

class TestSystemConfig : AbstractProjectConfig() {
	private val testPort = 8090

	override suspend fun beforeProject() =
		TestSystem(baseUrl = "http://localhost:$testPort")
			.with {
				httpClient()
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
					runner = { parameters ->
						System.setProperty("security.audience", "hollybike")
						System.setProperty("security.domain", "hollybike.eu.auth0.com")
						System.setProperty("security.realm", "hollybike")
						System.setProperty("security.secret", "test-secret")

						System.setProperty("storage.localPath", "./storage/tests")

						val dbUrl = parameters.firstOrNull { it.startsWith("database.jdbcUrl") }?.substringAfter("=")
						val dbUser = parameters.firstOrNull { it.startsWith("database.username") }?.substringAfter("=")
						val dbPass = parameters.firstOrNull { it.startsWith("database.password") }?.substringAfter("=")

						if (dbUrl != null && dbUser != null && dbPass != null) {
							System.setProperty("database.url", dbUrl)
							System.setProperty("database.username", dbUser)
							System.setProperty("database.password", dbPass)
						}

						System.setProperty("aws.accessKeyId", "minio-root-user")
						System.setProperty("aws.secretAccessKey", "minio-root-password")

						System.setProperty("port", testPort.toString())

						System.setProperty("is_test_env", "true")

						hollybike.api.run(
							isTestEnv = true,
						)
					}
				)
			}.run()

	override suspend fun afterProject() {
		TestSystem.stop()
	}
}