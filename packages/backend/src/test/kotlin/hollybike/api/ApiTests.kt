package hollybike.api

import com.trendyol.stove.testing.e2e.http.http
import com.trendyol.stove.testing.e2e.system.TestSystem.Companion.validate
import hollybike.api.utils.TokenStore
import io.kotest.core.spec.style.FunSpec
import io.kotest.matchers.shouldBe

val tokenStore = TokenStore()

class API : FunSpec({
	test("Should return welcome message") {
		validate {
			http {
				getResponse<String>(
					"/api",
					expect = { actual ->
						actual.status shouldBe 200
						actual.body() shouldBe "Bienvenue sur l'API hollyBike"
					}
				)
			}
		}
	}
})