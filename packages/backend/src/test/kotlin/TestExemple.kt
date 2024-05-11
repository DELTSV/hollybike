import hollybike.api.module
import io.ktor.client.request.*
import io.ktor.http.*
import io.ktor.server.testing.*
import org.testcontainers.containers.ComposeContainer
import org.testcontainers.containers.DockerComposeContainer
import org.testcontainers.containers.PostgreSQLContainer
import java.io.File
import kotlin.test.BeforeTest
import kotlin.test.Test
import kotlin.test.assertEquals

class TestExemple {
	@BeforeTest
	fun setup() {
		val container = PostgreSQLContainer("postgres:13.3")
			.withDatabaseName("hollybike")
			.withAccessToHost(true)

		container.addExposedPort(5432)

		println(container.host)
		println(container.getExposedPorts())

		container.run {
			start()
		}
	}

	@Test
	fun testRoot() = testApplication {
		application {
			module()
		}
		client.get("/").apply {
			assertEquals(HttpStatusCode.OK, status)
		}
	}
}
