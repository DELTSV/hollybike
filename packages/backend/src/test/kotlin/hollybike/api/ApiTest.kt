package hollybike.api

import hollybike.api.base.IntegrationSpec
import io.kotest.matchers.shouldBe
import io.ktor.client.request.*
import io.ktor.client.statement.*
import io.ktor.http.*

class ApiTest : IntegrationSpec({
	test("Should return 200 on root API endpoint") {
		onPremiseTestApp {
			it.get("/api").apply {
				status shouldBe HttpStatusCode.OK
				bodyAsText() shouldBe "Bienvenue sur l'API hollyBike"
			}
		}
	}

	test("Should return service unavailable on SMTP API endpoint") {
		onPremiseTestApp {
			it.get("/api/smtp").apply {
				status shouldBe HttpStatusCode.ServiceUnavailable
				bodyAsText() shouldBe "Service SMTP indisponible, configurer un server SMTP pour accéder à cette fonctionnalité"
			}
		}
	}

	test("Should return 404 on unknown API endpoint") {
		onPremiseTestApp {
			it.get("/api/unknown").apply {
				status shouldBe HttpStatusCode.NotFound
				bodyAsText() shouldBe "Chemin unknown inconnu"
			}
		}
	}
})