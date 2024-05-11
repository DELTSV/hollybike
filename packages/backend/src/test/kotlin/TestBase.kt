import hollybike.api.*
import io.ktor.server.testing.*
import org.junit.jupiter.api.BeforeAll
import org.testcontainers.containers.GenericContainer
import org.testcontainers.containers.PostgreSQLContainer
import org.testcontainers.junit.jupiter.Container
import org.testcontainers.junit.jupiter.Testcontainers

@Testcontainers
abstract class TestBase {
	companion object {
		var databaseConfig: ConfDB? = null
		var storageConfig: ConfStorage? = null

		@Container
		val database: PostgreSQLContainer<*> = PostgreSQLContainer("postgres:16.3")
			.withDatabaseName("hollybike")

		@Container
		val minio: GenericContainer<*> = GenericContainer("bitnami/minio:2024.5.10")
			.withEnv("MINIO_ROOT_USER", "minio-test-user")
			.withEnv("MINIO_ROOT_PASSWORD", "minio-test-password")
			.withEnv("MINIO_DEFAULT_BUCKETS", "hollybike")
			.withExposedPorts(9000)

		@JvmStatic
		@BeforeAll
		fun setUp() {
			database.start()
			minio.start()

			databaseConfig = ConfDB(
				url = database.jdbcUrl,
				username = database.username,
				password = database.password
			)

			storageConfig = ConfStorage(
				s3Url = "http://${minio.host}:${minio.getMappedPort(9000)}",
				s3BucketName = "hollybike",
				s3Region = "us-east-1",
				s3Password = "minio-test-password",
				s3Username = "minio-test-user"
			)

			Thread.sleep(5000)
		}
	}

	fun applicationConfig(block: suspend ApplicationTestBuilder.() -> Unit) = testApplication {
		application {
			loadCustomConfig(
				Conf(
					db = databaseConfig!!,
					security = ConfSecurity(
						audience = "audience",
						domain = "domain",
						realm = "realm",
						secret = "secret"
					),
					smtp = null,
					storage = storageConfig!!
				)
			)
			checkTestEnvironment()
			checkOnPremise()
			api()
		}

		block()
	}
}