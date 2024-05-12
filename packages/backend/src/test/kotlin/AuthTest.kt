import hollybike.api.types.association.EAssociationsStatus
import hollybike.api.types.association.TAssociation
import hollybike.api.types.auth.TLogin
import hollybike.api.types.user.EUserScope
import hollybike.api.types.user.EUserStatus
import hollybike.api.types.user.TUser
import io.kotest.matchers.equality.shouldBeEqualToIgnoringFields
import io.kotest.matchers.shouldBe
import io.ktor.client.call.*
import io.ktor.client.request.*
import io.ktor.http.*
import io.ktor.client.statement.*
import kotlinx.datetime.Instant

class AuthTest : IntegrationSpec({
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
				setBody(TLogin("root@hollybike.fr", "test"))
			}.apply {
				status shouldBe HttpStatusCode.Unauthorized
				bodyAsText() shouldBe "Mauvais mot de passe"
			}
		}
	}

	test("Should return the root user") {
		testApp {
			it.get("/api/users/me") {
				header("Authorization", "Bearer ${tokenStore.get("root@hollybike.fr")}")
			}.apply {
				status shouldBe HttpStatusCode.OK
				body<TUser>().shouldBeEqualToIgnoringFields(
					TUser(
						id = 1,
						email = "root@hollybike.fr",
						username = "root",
						scope = EUserScope.Root,
						status = EUserStatus.Enabled,
						lastLogin = Instant.DISTANT_PAST,
						association = TAssociation(
							id = 1,
							name = "Root Association",
							status = EAssociationsStatus.Enabled,
						),
						profilePicture = null
					),
					TUser::lastLogin
				)
			}
		}
	}
})
