import hollybike.api.*
import io.kotest.core.spec.style.FunSpec
import io.ktor.client.*
import io.ktor.client.plugins.contentnegotiation.*
import io.ktor.serialization.kotlinx.json.*
import io.ktor.server.testing.*
import org.testcontainers.containers.GenericContainer
import org.testcontainers.containers.PostgreSQLContainer
import org.testcontainers.junit.jupiter.Container
import org.testcontainers.junit.jupiter.Testcontainers

@Testcontainers
abstract class IntegrationSpec(body: FunSpec.() -> Unit = {}) : FunSpec({
	beforeTest {
		database.execInContainer(
			"psql",
			"-U",
			database.username,
			"-d",
			database.databaseName,
			"-c",
			"DROP SCHEMA public CASCADE; CREATE SCHEMA public;"
		)
	}

	body()
}) {
	companion object {
		@Container
		val database: PostgreSQLContainer<*> = PostgreSQLContainer("postgres:16.3").withDatabaseName("hollybike")

		@Container
		val minio: GenericContainer<*> =
			GenericContainer("bitnami/minio:2024.5.10").withEnv("MINIO_ROOT_USER", "minio-test-user")
				.withEnv("MINIO_ROOT_PASSWORD", "minio-test-password").withEnv("MINIO_DEFAULT_BUCKETS", "hollybike")
				.withExposedPorts(9000)

		val tokenStore = TokenStore()

		init {
			database.start()
			minio.start()

			Thread.sleep(5000)
		}

		fun testApp(block: suspend ApplicationTestBuilder.(c: HttpClient) -> Unit) = testApplication {
			System.setProperty("is_test_env", "true")

			val dbConf = ConfDB(
				url = database.jdbcUrl, username = database.username, password = database.password
			)

			val storageConfig = ConfStorage(
				s3Url = "http://${minio.host}:${minio.getMappedPort(9000)}",
				s3BucketName = "hollybike",
				s3Region = "us-east-1",
				s3Password = "minio-test-password",
				s3Username = "minio-test-user"
			)

			val config = Conf(
				db = dbConf, security = ConfSecurity(
					audience = "audience", domain = "domain", realm = "realm", secret = "secret"
				), smtp = null, storage = storageConfig
			)

			application {
				loadCustomConfig(config)
				checkTestEnvironment()
				configureSerialization()
				checkOnPremise()
				api()
			}

			val client = createClient {
				install(ContentNegotiation) {
					json()
				}
			}

			block(client)
		}
	}
}