/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api

import hollybike.api.base.IntegrationSpec
import io.kotest.matchers.shouldBe
import io.ktor.client.request.*
import io.ktor.client.statement.*
import io.ktor.http.*

class FrontendTest : IntegrationSpec({
	test("Should return the index.html page as root") {
		onPremiseTestApp {
			it.get("/").apply {
				status shouldBe HttpStatusCode.OK
				bodyAsText() shouldBe "root is working"
			}
		}
	}

	test("Should not return the index.html page as root in cloud mode") {
		cloudTestApp {
			it.get("/").apply {
				status shouldBe HttpStatusCode.NotFound
			}
		}
	}
})