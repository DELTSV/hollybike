package hollybike.api

import arrow.core.Option
import com.trendyol.stove.testing.e2e.http.http
import com.trendyol.stove.testing.e2e.system.TestSystem.Companion.validate
import hollybike.api.types.auth.TAuthInfo
import hollybike.api.types.auth.TLogin
import hollybike.api.types.user.TUser
import io.kotest.core.spec.style.FunSpec
import io.kotest.matchers.shouldBe
import io.kotest.matchers.shouldNotBe
import io.ktor.http.*

class Authentication : FunSpec({
	test("Should return 404 when user is unknown") {
		validate {
			http {
				postAndExpectBody<String>(
					"api/auth/login",
					Option(
						TLogin(
							email = "l.vandenbossche.jouvet@gmail.com",
							password = "1234"
						)
					),
					expect = { actual ->
						actual.status shouldBe HttpStatusCode.NotFound.value
						actual.body() shouldBe "Utilisateur inconnu"
					}
				)
			}
		}
	}

	test("Should login and return token") {
		validate {
			http {
				postAndExpectBody<TAuthInfo>(
					"/api/auth/login",
					Option(
						TLogin(
							email = "l.vandenbossche@gmail.com",
							password = "1234"
						)
					),
					expect = { actual ->
						actual.status shouldBe HttpStatusCode.OK.value

						val token = actual.body().token
						token shouldNotBe null

						tokenStore.store("l.vandenbossche@gmail.com", token)
					}
				)
			}
		}
	}

	test("Should get current user") {
		validate {
			http {
				getResponse<TUser>(
					"/api/users/me",
					token = tokenStore.get("l.vandenbossche@gmail.com"),
					expect = { actual ->
						actual.status shouldBe HttpStatusCode.OK.value
					}
				)
			}
		}
	}
})