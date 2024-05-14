package hollybike.api.base

import hollybike.api.*
import hollybike.api.services.storage.StorageMode
import hollybike.api.types.invitation.TInvitation
import hollybike.api.types.invitation.TInvitationCreation
import hollybike.api.types.user.EUserScope
import io.kotest.core.spec.style.FunSpec
import io.ktor.client.*
import io.ktor.client.call.*
import io.ktor.client.plugins.contentnegotiation.*
import io.ktor.client.request.*
import io.ktor.http.*
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

		suspend fun generateInvitation(
			client: HttpClient,
			sender: String,
			role: EUserScope = EUserScope.User,
			maxUses: Int = 1,
			disabled: Boolean = false
		): Parameters {
			val response = client.post("/api/invitation") {
				header("Authorization", "Bearer ${tokenStore.get(sender)}")
				header("Host", "localhost")
				contentType(ContentType.Application.Json)
				setBody(
					TInvitationCreation(
						role = role,
						association = null,
						maxUses = maxUses,
						expiration = null
					),
				)
			}

			if (response.status != HttpStatusCode.OK) {
				throw Exception("Error while generating the invitation")
			}

			val body = response.body<TInvitation>()

			if (disabled) {
				disableInvitation(client, sender, body.id)
			}

			return body.link?.parseUrlEncodedParameters() ?: throw Exception("No link in the response")
		}

		private suspend fun disableInvitation(
			client: HttpClient,
			sender: String,
			invitationId: Int
		) {
			val response = client.patch("/api/invitation/$invitationId/disable") {
				header("Authorization", "Bearer ${tokenStore.get(sender)}")
				header("Host", "localhost")
				contentType(ContentType.Application.Json)
			}

			if (response.status != HttpStatusCode.OK) {
				throw Exception("Error while disabling the invitation")
			}
		}

		fun testApp(baseConfig: BaseConfig = BaseConfig(), block: suspend ApplicationTestBuilder.(c: HttpClient) -> Unit) = testApplication {
			System.setProperty("is_test_env", "true")

			val dbConf = ConfDB(
				url = database.jdbcUrl, username = database.username, password = database.password
			)

			val storageConfig = when(baseConfig.storageMode) {
				StorageMode.S3 -> ConfStorage(
					s3Url = "http://${minio.host}:${minio.getMappedPort(9000)}",
					s3BucketName = "hollybike",
					s3Region = "us-east-1",
					s3Password = "minio-test-password",
					s3Username = "minio-test-user"
				)

				StorageMode.LOCAL -> ConfStorage(
					localPath = "storage/tests"
				)
				StorageMode.FTP -> ConfStorage(
					localPath = "storage/tests"
				)
			}

			val config = Conf(
				db = dbConf, security = ConfSecurity(
					audience = "audience", domain = "domain", realm = "realm", secret = "secret"
				), smtp = null, storage = storageConfig
			)

			environment {
				developmentMode = false
			}

			application {
				loadCustomConfig(config)
				checkTestEnvironment()
				configureSerialization()
				forceMode(isOnPremise = baseConfig.isOnPremise)
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