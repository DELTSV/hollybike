package hollybike.api

import com.trendyol.stove.testing.e2e.ktor
import com.trendyol.stove.testing.e2e.system.TestSystem
import io.kotest.core.spec.style.FunSpec
import io.kotest.matchers.shouldBe
import com.trendyol.stove.testing.e2e.http.http
import com.trendyol.stove.testing.e2e.http.httpClient
import com.trendyol.stove.testing.e2e.system.TestSystem.Companion.validate

import io.kotest.core.config.AbstractProjectConfig

class TestSystemConfig : AbstractProjectConfig() {
	override suspend fun beforeProject() =
		TestSystem(baseUrl = "http://localhost:8080")
			.with {
				httpClient()
				ktor(
					withParameters = listOf(
						"port=8080",
					),
					runner = {
						run(isTestEnv = true)
					}
				)
			}.run()

	override suspend fun afterProject() {
		TestSystem.stop()
	}
}

class API : FunSpec({
	test("Should return welcome message") {
		validate {
			http {
				get<String>(
					"/api",
				) { actual ->
					actual shouldBe "Bienvenue sur l'API hollyBike"
				}
			}
		}
	}
})
