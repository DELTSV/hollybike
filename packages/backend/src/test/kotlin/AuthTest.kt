import hollybike.api.types.auth.TLogin
import io.ktor.client.request.*
import io.ktor.http.*
import io.ktor.serialization.kotlinx.json.*
import io.ktor.client.plugins.contentnegotiation.ContentNegotiation
import io.ktor.client.statement.*
import org.junit.jupiter.api.Test
import kotlin.test.assertEquals

class AuthTest : TestBase() {
	@Test
	fun `Should not login because the user does not exists`() = testApp {
		val client = createClient {
			install(ContentNegotiation) {
				json()
			}
		}

		client.post("/api/auth/login") {
			contentType(ContentType.Application.Json)
			setBody(TLogin("notfound@hollybike.fr", "test"))
		}.apply {
			assertEquals(HttpStatusCode.NotFound, status)
			assertEquals("Utilisateur inconnu", bodyAsText())
		}
	}

	@Test
	fun `Should not login because of bad credentials`() = testApp {
		val client = createClient {
			install(ContentNegotiation) {
				json()
			}
		}

		client.post("/api/auth/login") {
			contentType(ContentType.Application.Json)
			setBody(TLogin("root@hollybike.fr", "test"))
		}.apply {
			assertEquals(HttpStatusCode.Unauthorized, status)
			assertEquals("Mauvais mot de passe", bodyAsText())
		}
	}
}