package hollybike.api

import hollybike.api.base.IntegrationSpec
import hollybike.api.types.auth.TAuthInfo
import hollybike.api.types.auth.TLogin
import hollybike.api.types.auth.TSignup
import hollybike.api.types.user.EUserScope
import io.kotest.matchers.shouldBe
import io.kotest.matchers.shouldNotBe
import io.ktor.client.call.*
import io.ktor.client.request.*
import io.ktor.http.*
import io.ktor.client.statement.*

class AuthenticationTest : IntegrationSpec({
	test("Should not login because the user does not exists") {
		testApp {
			it.post("/api/auth/login") {
				contentType(ContentType.Application.Json)
				setBody(TLogin("notfound@hollybike.fr", "test"))
			}.apply {
				status shouldBe HttpStatusCode.NotFound
				bodyAsText() shouldBe "Utilisateur inconnu"
			}
		}
	}

	test("Should not login because of bad credentials") {
		testApp {
			it.post("/api/auth/login") {
				contentType(ContentType.Application.Json)
				setBody(TLogin("root@hollybike.fr", "password"))
			}.apply {
				status shouldBe HttpStatusCode.Unauthorized
				bodyAsText() shouldBe "Mauvais mot de passe"
			}
		}
	}

	test("Should login the user and return the token") {
		testApp {
			it.post("/api/auth/login") {
				contentType(ContentType.Application.Json)
				setBody(TLogin("root@hollybike.fr", "test"))
			}.apply {
				status shouldBe HttpStatusCode.OK
				body<TAuthInfo>().token shouldNotBe null
			}
		}
	}

	test("Should sign up the user to the association") {
		testApp {
			val invitation = generateInvitation(it, "admin1@hollybike.fr")

			it.post("/api/auth/signin") {
				contentType(ContentType.Application.Json)
				header("Host", "localhost")
				setBody(
					TSignup(
						email = "account1@hollybike.fr",
						password = "test",
						username = "account1",
						verify = invitation["verify"]!!,
						association = invitation["association"]!!.toInt(),
						role = EUserScope.User,
						invitation = invitation["invitation"]!!.toInt()
					)
				)
			}.apply {
				status shouldBe HttpStatusCode.OK
				body<TAuthInfo>().token shouldNotBe null
			}
		}
	}
})
