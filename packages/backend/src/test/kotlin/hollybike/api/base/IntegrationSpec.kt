package hollybike.api.base

import hollybike.api.*
import hollybike.api.services.storage.StorageMode
import hollybike.api.stores.TokenStore
import hollybike.api.stores.UserStore
import hollybike.api.types.invitation.TInvitation
import hollybike.api.types.invitation.TInvitationCreation
import hollybike.api.types.user.EUserScope
import io.kotest.core.spec.style.FunSpec
import io.kotest.matchers.shouldBe
import io.ktor.client.*
import io.ktor.client.call.*
import io.ktor.client.plugins.contentnegotiation.*
import io.ktor.client.request.*
import io.ktor.client.request.forms.*
import io.ktor.http.*
import io.ktor.serialization.kotlinx.json.*
import io.ktor.server.testing.*
import org.testcontainers.containers.FixedHostPortGenericContainer
import org.testcontainers.containers.GenericContainer
import org.testcontainers.containers.PostgreSQLContainer
import org.testcontainers.junit.jupiter.Container
import org.testcontainers.junit.jupiter.Testcontainers
import java.io.File
import java.net.ServerSocket

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

		@Container
		val ftp: FixedHostPortGenericContainer<*> =
			FixedHostPortGenericContainer("fauria/vsftpd:latest").withEnv("FTP_USER", "ftp-test-user")
				.withEnv("FTP_PASS", "ftp-test-password")

		val tokenStore = TokenStore()

		init {
			database.start()
			minio.start()

			ftp.withExposedPorts(21)

			var freePort: Int
			ServerSocket(0).use { socket ->
				freePort = socket.getLocalPort()
			}

			ftp.withFixedExposedPort(freePort, freePort)
				.withEnv("PASV_MIN_PORT", freePort.toString())
				.withEnv("PASV_MAX_PORT", freePort.toString())

			ftp.start()

			println("Initialized the containers")

			Thread.sleep(5000)
		}

		suspend fun uploadProfileImageInStorage(client: HttpClient, sender: Pair<Int, String>) {
			val file = File(
				javaClass.classLoader.getResource("profile.jpg")?.file ?: error("File profile.jpg not found")
			)

			client.post("/api/users/me/profile-picture") {
				val boundary = "WebAppBoundary"
				auth(sender)
				setBody(
					MultiPartFormDataContent(
						formData {
							append("file", file.readBytes(), Headers.build {
								append(HttpHeaders.ContentType, "image/jpeg")
								append(HttpHeaders.ContentDisposition, "filename=\"profile.jpg\"")
							})
						},
						boundary,
						ContentType.MultiPart.FormData.withParameter("boundary", boundary)
					)
				)
			}.apply {
				status shouldBe HttpStatusCode.OK
			}
		}

		suspend fun generateInvitation(
			client: HttpClient,
			sender: Pair<Int, String>,
			role: EUserScope = EUserScope.User,
			maxUses: Int = 1,
			disabled: Boolean = false
		): Parameters {
			val response = client.post("/api/invitation") {
				auth(sender)
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
			sender: Pair<Int, String>,
			invitationId: Int
		) {
			val response = client.patch("/api/invitation/$invitationId/disable") {
				auth(sender)
				header("Host", "localhost")
				contentType(ContentType.Application.Json)
			}

			if (response.status != HttpStatusCode.OK) {
				throw Exception("Error while disabling the invitation")
			}
		}

		private fun testApp(
			baseConfig: BaseConfig,
			block: suspend ApplicationTestBuilder.(c: HttpClient) -> Unit
		) = testApplication {
			System.setProperty("is_test_env", "true")

			val dbConf = ConfDB(
				url = database.jdbcUrl, username = database.username, password = database.password
			)

			val storageConfig = when (baseConfig.storageMode) {
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
					ftpServer = "ftp://${ftp.host}:${ftp.getMappedPort(21)}",
					ftpUsername = "ftp-test-user",
					ftpPassword = "ftp-test-password",
					ftpDirectory = "storage"
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
				checkEnvironment()
				configureSerialization()
				forceMode(isOnPremise = baseConfig.isOnPremise)
				api()
				frontend()
			}

			val client = createClient {
				install(ContentNegotiation) {
					json()
				}
			}

			block(client)
		}

		fun cloudTestApp(
			block: suspend ApplicationTestBuilder.(c: HttpClient) -> Unit
		) = testApp(BaseConfig(StorageMode.S3, isOnPremise = false), block)

		fun onPremiseTestApp(
			storageMode: StorageMode = StorageMode.LOCAL,
			block: suspend ApplicationTestBuilder.(c: HttpClient) -> Unit
		) = testApp(BaseConfig(storageMode), block)
	}
}