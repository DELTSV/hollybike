import io.kotest.matchers.shouldBe
import io.ktor.client.request.*
import io.ktor.client.statement.*
import io.ktor.http.*

class EventTest : IntegrationSpec({
	test("Should return 200 on root API endpoint") {
		testApp {
			it.get("/api").apply {
				status shouldBe HttpStatusCode.OK
				bodyAsText() shouldBe "Bienvenue sur l'API hollyBike"
			}
		}
	}
})