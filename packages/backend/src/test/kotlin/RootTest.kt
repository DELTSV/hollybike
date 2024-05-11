import io.ktor.client.call.*
import io.ktor.client.request.*
import io.ktor.http.*
import org.junit.jupiter.api.Test
import kotlin.test.assertEquals

class RootTest : TestBase() {
	@Test
	fun `Should return 200 on root API endpoint`() = testApp {
		client.get("/api").apply {
			assertEquals(HttpStatusCode.OK, status)
			assertEquals("Bienvenue sur l'API hollyBike", body())
		}
	}
}