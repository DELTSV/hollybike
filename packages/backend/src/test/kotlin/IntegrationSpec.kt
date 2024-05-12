import com.auth0.jwt.JWT
import com.auth0.jwt.algorithms.Algorithm
import hollybike.api.*
import hollybike.api.types.user.EUserScope
import io.kotest.core.spec.style.FunSpec
import io.ktor.server.testing.*
import org.testcontainers.containers.GenericContainer
import org.testcontainers.containers.PostgreSQLContainer
import org.testcontainers.junit.jupiter.Container
import org.testcontainers.junit.jupiter.Testcontainers
import java.util.*

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

		val tokenStore = mutableMapOf<String, String>()
		private val users = mutableMapOf(
			"root@hollybike.fr" to EUserScope.Root,
			"user1@hollybike.fr" to EUserScope.User,
			"user2@hollybike.fr" to EUserScope.User,
			"admin1@hollybike.fr" to EUserScope.Admin,
			"admin2@hollybike.fr" to EUserScope.Admin,
		)

		@Container
		val minio: GenericContainer<*> =
			GenericContainer("bitnami/minio:2024.5.10").withEnv("MINIO_ROOT_USER", "minio-test-user")
				.withEnv("MINIO_ROOT_PASSWORD", "minio-test-password").withEnv("MINIO_DEFAULT_BUCKETS", "hollybike")
				.withExposedPorts(9000)

		init {
			database.start()
			minio.start()

			users.forEach { (email, scope) ->
				tokenStore[email] = generateJWT(email, scope)
			}

			Thread.sleep(5000)
		}

		private fun generateJWT(email: String, scope: EUserScope) =
			JWT.create().withAudience("audience").withIssuer("domain").withClaim("email", email)
				.withClaim("scope", scope.value).withExpiresAt(Date(System.currentTimeMillis() + 60000 * 60 * 24))
				.sign(Algorithm.HMAC256("secret"))

		fun testApp(block: suspend ApplicationTestBuilder.() -> Unit) = testApplication {
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

			block()
		}
	}
}