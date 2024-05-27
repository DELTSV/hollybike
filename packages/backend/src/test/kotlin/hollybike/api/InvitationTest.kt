package hollybike.api

import hollybike.api.base.IntegrationSpec
import hollybike.api.base.auth
import hollybike.api.stores.UserStore
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
			onPremiseTestApp {
				it.post("/api/invitation") {
					auth(UserStore.admin1)
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
				onPremiseTestApp {
					it.post("/api/invitation") {
						auth(UserStore.admin1)
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
			onPremiseTestApp {
				it.post("/api/invitation") {
					auth(UserStore.user1)
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
			onPremiseTestApp {
				generateInvitation(it, UserStore.admin1)

				it.post("/api/invitation") {
					auth(UserStore.admin1)
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
			onPremiseTestApp {
				it.post("/api/invitation") {
					auth(UserStore.root)
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
			onPremiseTestApp {
				val invitation = generateInvitation(it, UserStore.admin1)

				it.patch("/api/invitation/${invitation["invitation"]!!.toInt()}/disable") {
					auth(UserStore.admin1)
					header("Host", "localhost")
				}.apply {
					status shouldBe HttpStatusCode.OK

					body<TInvitation>().status shouldBe EInvitationStatus.Disabled
				}
			}
		}

		test("Should not disable the invitation because it does not exist") {
			onPremiseTestApp {
				it.patch("/api/invitation/20/disable") {
					auth(UserStore.admin1)
					header("Host", "localhost")
				}.apply {
					status shouldBe HttpStatusCode.NotFound
					bodyAsText() shouldBe "Invitation inconnue"
				}
			}
		}

		test("Should not disable the invitation if the host is not provided") {
			onPremiseTestApp {
				val invitation = generateInvitation(it, UserStore.admin1)

				it.patch("/api/invitation/${invitation["invitation"]!!.toInt()}/disable") {
					auth(UserStore.admin1)
				}.apply {
					status shouldBe HttpStatusCode.BadRequest
					bodyAsText() shouldBe "Aucun Host fourni"
				}
			}
		}

		test("Should not disable the invitation because the user is not an admin") {
			onPremiseTestApp {
				val invitation = generateInvitation(it, UserStore.admin1)

				it.patch("/api/invitation/${invitation["invitation"]!!.toInt()}/disable") {
					auth(UserStore.user1)
					header("Host", "localhost")
				}.apply {
					status shouldBe HttpStatusCode.Forbidden
					bodyAsText() shouldBe "You don't have sufficient permissions to access this resource"
				}
			}
		}

		test("Should not disable the invitation because the user is not on the same association") {
			onPremiseTestApp {
				val invitation = generateInvitation(it, UserStore.admin1)

				it.patch("/api/invitation/${invitation["invitation"]!!.toInt()}/disable") {
					auth(UserStore.admin2)
					header("Host", "localhost")
				}.apply {
					status shouldBe HttpStatusCode.Forbidden
				}
			}
		}

		test("Should disable the invitation if the user is a root but not on the same association") {
			onPremiseTestApp {
				val invitation = generateInvitation(it, UserStore.admin1)

				it.patch("/api/invitation/${invitation["invitation"]!!.toInt()}/disable") {
					auth(UserStore.root)
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
			onPremiseTestApp {
				it.get("/api/invitation") {
					auth(UserStore.admin1)
					header("Host", "localhost")
				}.apply {
					status shouldBe HttpStatusCode.OK

					body<List<TInvitation>>() shouldBe emptyList()
				}
			}
		}

		test("Should not return the list of invitations because the user is not an admin") {
			onPremiseTestApp {
				it.get("/api/invitation") {
					auth(UserStore.user1)
					header("Host", "localhost")
				}.apply {
					status shouldBe HttpStatusCode.Forbidden

					bodyAsText() shouldBe "You don't have sufficient permissions to access this resource"
				}
			}
		}

		test("Should not return the list of invitations if the host is not provided") {
			onPremiseTestApp {
				it.get("/api/invitation") {
					auth(UserStore.admin1)
				}.apply {
					status shouldBe HttpStatusCode.BadRequest

					bodyAsText() shouldBe "Aucun Host fourni"
				}
			}
		}

		test("Should return list of invitations with links") {
			onPremiseTestApp {
				generateInvitation(it, UserStore.admin1)

				it.get("/api/invitation") {
					auth(UserStore.admin1)
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
			onPremiseTestApp {
				generateInvitation(it, UserStore.admin1, disabled = true)

				it.get("/api/invitation") {
					auth(UserStore.admin1)
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