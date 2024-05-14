package hollybike.api

import hollybike.api.base.IntegrationSpec
import hollybike.api.types.invitation.EInvitationStatus
import hollybike.api.types.invitation.TInvitation
import hollybike.api.types.invitation.TInvitationCreation
import hollybike.api.types.user.EUserScope
import io.kotest.matchers.equality.shouldBeEqualToIgnoringFields
import io.kotest.matchers.shouldBe
import io.kotest.matchers.shouldNotBe
import io.ktor.client.call.*
import io.ktor.client.request.*
import io.ktor.client.statement.*
import io.ktor.http.*
import kotlinx.datetime.Instant

class InvitationTest : IntegrationSpec({
	context("Create invitation") {
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

		test("Should not create the invitation because it already exists") {
			testApp {
				generateInvitation(it, "admin1@hollybike.fr")

				it.post("/api/invitation") {
					header("Authorization", "Bearer ${tokenStore.get("admin1@hollybike.fr")}")
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
					status shouldBe HttpStatusCode.Conflict
					bodyAsText() shouldBe "Une invitation avec ces paramètres existe déjà"
				}
			}
		}

		test("Should not create the invitation because the association does not exist") {
			testApp {
				it.post("/api/invitation") {
					header("Authorization", "Bearer ${tokenStore.get("root@hollybike.fr")}")
					header("Host", "localhost")
					contentType(ContentType.Application.Json)
					setBody(
						TInvitationCreation(
							role = EUserScope.User,
							association = 20,
							maxUses = 1,
							expiration = null
						),
					)
				}.apply {
					status shouldBe HttpStatusCode.NotFound
					bodyAsText() shouldBe "Association inconnue"
				}
			}
		}
	}

	context("Disable invitation") {
		test("Should disable the invitation") {
			testApp {
				val invitation = generateInvitation(it, "admin1@hollybike.fr")

				it.patch("/api/invitation/${invitation["invitation"]!!.toInt()}/disable") {
					header("Authorization", "Bearer ${tokenStore.get("admin1@hollybike.fr")}")
					header("Host", "localhost")
				}.apply {
					status shouldBe HttpStatusCode.OK

					body<TInvitation>().status shouldBe EInvitationStatus.Disabled
				}
			}
		}

		test("Should not disable the invitation because it does not exist") {
			testApp {
				it.patch("/api/invitation/20/disable") {
					header("Authorization", "Bearer ${tokenStore.get("admin1@hollybike.fr")}")
					header("Host", "localhost")
				}.apply {
					status shouldBe HttpStatusCode.NotFound
					bodyAsText() shouldBe "Invitation inconnue"
				}
			}
		}

		test("Should not disable the invitation if the host is not provided") {
			testApp {
				val invitation = generateInvitation(it, "admin1@hollybike.fr")

				it.patch("/api/invitation/${invitation["invitation"]!!.toInt()}/disable") {
					header("Authorization", "Bearer ${tokenStore.get("admin1@hollybike.fr")}")
				}.apply {
					status shouldBe HttpStatusCode.BadRequest
					bodyAsText() shouldBe "Aucun Host fourni"
				}
			}
		}

		test("Should not disable the invitation because the user is not an admin") {
			testApp {
				val invitation = generateInvitation(it, "admin1@hollybike.fr")

				it.patch("/api/invitation/${invitation["invitation"]!!.toInt()}/disable") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
					header("Host", "localhost")
				}.apply {
					status shouldBe HttpStatusCode.Forbidden
					bodyAsText() shouldBe "You don't have sufficient permissions to access this resource"
				}
			}
		}

		test("Should not disable the invitation because the user is not on the same association") {
			testApp {
				val invitation = generateInvitation(it, "admin1@hollybike.fr")

				it.patch("/api/invitation/${invitation["invitation"]!!.toInt()}/disable") {
					header("Authorization", "Bearer ${tokenStore.get("admin2@hollybike.fr")}")
					header("Host", "localhost")
				}.apply {
					status shouldBe HttpStatusCode.Forbidden
				}
			}
		}

		test("Should disable the invitation if the user is a root but not on the same association") {
			testApp {
				val invitation = generateInvitation(it, "admin1@hollybike.fr")

				it.patch("/api/invitation/${invitation["invitation"]!!.toInt()}/disable") {
					header("Authorization", "Bearer ${tokenStore.get("root@hollybike.fr")}")
					header("Host", "localhost")
				}.apply {
					status shouldBe HttpStatusCode.OK

					body<TInvitation>().status shouldBe EInvitationStatus.Disabled
				}
			}
		}
	}

	context("Get invitations") {
		test("Should return an empty list of invitations") {
			testApp {
				it.get("/api/invitation") {
					header("Authorization", "Bearer ${tokenStore.get("admin1@hollybike.fr")}")
					header("Host", "localhost")
				}.apply {
					status shouldBe HttpStatusCode.OK

					body<List<TInvitation>>() shouldBe emptyList()
				}
			}
		}

		test("Should not return the list of invitations because the user is not an admin") {
			testApp {
				it.get("/api/invitation") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
					header("Host", "localhost")
				}.apply {
					status shouldBe HttpStatusCode.Forbidden

					bodyAsText() shouldBe "You don't have sufficient permissions to access this resource"
				}
			}
		}

		test("Should not return the list of invitations if the host is not provided") {
			testApp {
				it.get("/api/invitation") {
					header("Authorization", "Bearer ${tokenStore.get("admin1@hollybike.fr")}")
				}.apply {
					status shouldBe HttpStatusCode.BadRequest

					bodyAsText() shouldBe "Aucun Host fourni"
				}
			}
		}

		test("Should return list of invitations with links") {
			testApp {
				generateInvitation(it, "admin1@hollybike.fr")

				it.get("/api/invitation") {
					header("Authorization", "Bearer ${tokenStore.get("admin1@hollybike.fr")}")
					header("Host", "localhost")
				}.apply {
					status shouldBe HttpStatusCode.OK

					body<List<TInvitation>>().size shouldBe 1

					body<List<TInvitation>>().forEach { invitation ->
						invitation.link shouldNotBe null
					}
				}
			}
		}

		test("Should return list of disabled invitations without links") {
			testApp {
				generateInvitation(it, "admin1@hollybike.fr", disabled = true)

				it.get("/api/invitation") {
					header("Authorization", "Bearer ${tokenStore.get("admin1@hollybike.fr")}")
					header("Host", "localhost")
				}.apply {
					status shouldBe HttpStatusCode.OK

					body<List<TInvitation>>().size shouldBe 1

					body<List<TInvitation>>().forEach { invitation ->
						invitation.link shouldBe null
					}
				}
			}
		}
	}
})