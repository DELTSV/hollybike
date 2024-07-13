package hollybike.api

import hollybike.api.base.IntegrationSpec
import hollybike.api.base.value
import hollybike.api.stores.UserStore
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
	context("Login user") {
		test("Should not login because the user does not exists") {
			onPremiseTestApp {
				it.post("/api/auth/login") {
					contentType(ContentType.Application.Json)
					setBody(TLogin(UserStore.unknown.value, "test"))
				}.apply {
					status shouldBe HttpStatusCode.NotFound
					bodyAsText() shouldBe "Utilisateur inconnu"
				}
			}
		}

		test("Should not login because of bad credentials") {
			onPremiseTestApp {
				it.post("/api/auth/login") {
					contentType(ContentType.Application.Json)
					setBody(TLogin(UserStore.root.value, "password"))
				}.apply {
					status shouldBe HttpStatusCode.Unauthorized
					bodyAsText() shouldBe "Mauvais mot de passe"
				}
			}
		}

		test("Should not login because the user is disabled") {
			onPremiseTestApp {
				it.post("/api/auth/login") {
					contentType(ContentType.Application.Json)
					setBody(TLogin(UserStore.disabled1.value, "test"))
				}.apply {
					status shouldBe HttpStatusCode.Forbidden
				}
			}
		}

		test("Should not login because the association is disabled") {
			onPremiseTestApp {
				it.post("/api/auth/login") {
					contentType(ContentType.Application.Json)
					setBody(TLogin(UserStore.user6.value, "test"))
				}.apply {
					status shouldBe HttpStatusCode.Forbidden
				}
			}
		}

		test("Should login the user and return the token") {
			onPremiseTestApp {
				it.post("/api/auth/login") {
					contentType(ContentType.Application.Json)
					setBody(TLogin(UserStore.root.value, "test"))
				}.apply {
					status shouldBe HttpStatusCode.OK
					body<TAuthInfo>().token shouldNotBe null
				}
			}
		}
	}

	context("Sign up user") {
		test("Should sign up the user to the association") {
			onPremiseTestApp {
				val invitation = generateInvitation(it, UserStore.admin1)

				it.post("/api/auth/signin") {
					contentType(ContentType.Application.Json)
					setBody(
						TSignup(
							email = UserStore.new.value,
							password = "Test1234",
							username = "new_account",
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

		test("Should not sign up the user with invalid email address") {
			onPremiseTestApp {
				val invitation = generateInvitation(it, UserStore.admin1)

				it.post("/api/auth/signin") {
					contentType(ContentType.Application.Json)
					setBody(
						TSignup(
							email = "invalid_email",
							password = "test",
							username = "new_account",
							verify = invitation["verify"]!!,
							association = invitation["association"]!!.toInt(),
							role = EUserScope.User,
							invitation = invitation["invitation"]!!.toInt()
						)
					)
				}.apply {
					status shouldBe HttpStatusCode.BadRequest
					bodyAsText() shouldBe "Email invalide"
				}
			}
		}

		listOf("test", "TEST", "Test", "Test123").forEach { password ->
			test("Should not sign up user if the password is invalid") {
				onPremiseTestApp {
					val invitation = generateInvitation(it, UserStore.admin1)

					it.post("/api/auth/signin") {
						contentType(ContentType.Application.Json)
						setBody(
							TSignup(
								email = UserStore.new.value,
								password = password,
								username = "new_account",
								verify = invitation["verify"]!!,
								association = invitation["association"]!!.toInt(),
								role = EUserScope.User,
								invitation = invitation["invitation"]!!.toInt()
							)
						)
					}.apply {
						status shouldBe HttpStatusCode.BadRequest
					}
				}
			}
		}

		test("Should not sign up the user if the email is already used") {
			onPremiseTestApp {
				val invitation = generateInvitation(it, UserStore.admin1)

				it.post("/api/auth/signin") {
					contentType(ContentType.Application.Json)
					setBody(
						TSignup(
							email = UserStore.user1.value,
							password = "Test1234",
							username = "new_account",
							verify = invitation["verify"]!!,
							association = invitation["association"]!!.toInt(),
							role = EUserScope.User,
							invitation = invitation["invitation"]!!.toInt()
						)
					)
				}.apply {
					status shouldBe HttpStatusCode.Conflict
					bodyAsText() shouldBe "L'utilisateur existe déjà"
				}
			}
		}

		test("Should not sign up the user with bad invitation id") {
			onPremiseTestApp {
				val invitation = generateInvitation(it, UserStore.admin1)

				it.post("/api/auth/signin") {
					contentType(ContentType.Application.Json)
					setBody(
						TSignup(
							email = UserStore.new.value,
							password = "test",
							username = "new_account",
							verify = invitation["verify"]!!,
							association = invitation["association"]!!.toInt(),
							role = EUserScope.User,
							invitation = 20
						)
					)
				}.apply {
					status shouldBe HttpStatusCode.Forbidden
				}
			}
		}

		test("Should not sign up the user with bad association id") {
			onPremiseTestApp {
				val invitation = generateInvitation(it, UserStore.admin1)

				it.post("/api/auth/signin") {
					contentType(ContentType.Application.Json)
					setBody(
						TSignup(
							email = UserStore.new.value,
							password = "test",
							username = "new_account",
							verify = invitation["verify"]!!,
							association = 20,
							role = EUserScope.User,
							invitation = invitation["invitation"]!!.toInt()
						)
					)
				}.apply {
					status shouldBe HttpStatusCode.Forbidden
				}
			}
		}

		test("Should not sign up the user with bad user scope") {
			onPremiseTestApp {
				val invitation = generateInvitation(it, UserStore.admin1)

				it.post("/api/auth/signin") {
					contentType(ContentType.Application.Json)
					setBody(
						TSignup(
							email = UserStore.new.value,
							password = "test",
							username = "new_account",
							verify = invitation["verify"]!!,
							association = invitation["association"]!!.toInt(),
							role = EUserScope.Admin,
							invitation = invitation["invitation"]!!.toInt()
						)
					)
				}.apply {
					status shouldBe HttpStatusCode.Forbidden
				}
			}
		}

		test("Should not sign up the user with bad verify signature") {
			onPremiseTestApp {
				val invitation = generateInvitation(it, UserStore.admin1)

				it.post("/api/auth/signin") {
					contentType(ContentType.Application.Json)
					setBody(
						TSignup(
							email = UserStore.new.value,
							password = "test",
							username = "new_account",
							verify = "invalid_signature",
							association = invitation["association"]!!.toInt(),
							role = EUserScope.User,
							invitation = invitation["invitation"]!!.toInt()
						)
					)
				}.apply {
					status shouldBe HttpStatusCode.Forbidden
				}
			}
		}

		test("Should not sign up the user with used invitation") {
			onPremiseTestApp {
				val invitation = generateInvitation(it, UserStore.admin1, maxUses = 0)

				it.post("/api/auth/signin") {
					contentType(ContentType.Application.Json)
					setBody(
						TSignup(
							email = UserStore.new.value,
							password = "test",
							username = "new_account",
							verify = invitation["verify"]!!,
							association = invitation["association"]!!.toInt(),
							role = EUserScope.User,
							invitation = invitation["invitation"]!!.toInt()
						)
					)
				}.apply {
					status shouldBe HttpStatusCode.NotFound
					bodyAsText() shouldBe "Aucune invitation valide"
				}
			}
		}
	}
})
