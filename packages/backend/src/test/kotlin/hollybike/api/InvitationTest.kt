package hollybike.api

import hollybike.api.base.IntegrationSpec
import hollybike.api.types.invitation.EInvitationStatus
import hollybike.api.types.invitation.TInvitation
import hollybike.api.types.invitation.TInvitationCreation
import hollybike.api.types.user.EUserScope
import io.kotest.matchers.equality.shouldBeEqualToIgnoringFields
import io.kotest.matchers.shouldBe
import io.ktor.client.call.*
import io.ktor.client.request.*
import io.ktor.client.statement.*
import io.ktor.http.*
import kotlinx.datetime.Instant

class InvitationTest : IntegrationSpec({
	test("Should not create the invitation link because no host is provided") {
		testApp {
			it.post("/api/invitation") {
				header("Authorization", "Bearer ${tokenStore.get("admin1@hollybike.fr")}")
				contentType(ContentType.Application.Json)
				setBody(
					TInvitationCreation(
						role = EUserScope.User,
						association = null,
						maxUses = 1,
						expiration = null
					)
				)
			}.apply {
				status shouldBe HttpStatusCode.BadRequest
				bodyAsText() shouldBe "Aucun Host fourni"
			}
		}
	}

	listOf(
		TInvitationCreation(
			role = EUserScope.User,
			association = null,
			maxUses = 1,
			expiration = null
		),
		TInvitationCreation(
			role = EUserScope.User,
			association = 2,
			maxUses = 5,
			expiration = Instant.DISTANT_FUTURE
		),
		TInvitationCreation(
			role = EUserScope.Admin,
			association = null,
			maxUses = 20,
			expiration = null
		),
		TInvitationCreation(
			role = EUserScope.Admin,
			association = 2,
			maxUses = 20,
			expiration = null
		),
	).forEach { invitationCreation ->
		test("Should return create the invitation link") {
			testApp {
				it.post("/api/invitation") {
					header("Authorization", "Bearer ${tokenStore.get("admin1@hollybike.fr")}")
					header("Host", "localhost")
					contentType(ContentType.Application.Json)
					setBody(
						invitationCreation
					)
				}.apply {
					status shouldBe HttpStatusCode.OK

					body<TInvitation>().shouldBeEqualToIgnoringFields(
						TInvitation(
							id = 1,
							role = invitationCreation.role,
							maxUses = invitationCreation.maxUses,
							uses = 0,
							creation = Instant.DISTANT_PAST,
							expiration = invitationCreation.expiration,
							status = EInvitationStatus.Enabled
						),
						TInvitation::link,
						TInvitation::creation
					)
				}
			}
		}
	}

	test("Should not create the invitation link because the user is not an admin") {
		testApp {
			it.post("/api/invitation") {
				header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
				header("Host", "localhost")
				contentType(ContentType.Application.Json)
				setBody(
					TInvitationCreation(
						role = EUserScope.User,
						association = null,
						maxUses = 1,
						expiration = null
					),
				)
			}.apply {
				status shouldBe HttpStatusCode.Forbidden
				bodyAsText() shouldBe "You don't have sufficient permissions to access this resource"
			}
		}
	}
})