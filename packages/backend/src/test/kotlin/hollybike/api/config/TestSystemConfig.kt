package hollybike.api.config

import com.trendyol.stove.testing.e2e.http.httpClient
import com.trendyol.stove.testing.e2e.ktor
import com.trendyol.stove.testing.e2e.system.TestSystem
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
						hollybike.api.run(isTestEnv = true)
					}
				)
			}.run()

	override suspend fun afterProject() {
		TestSystem.stop()
	}
}