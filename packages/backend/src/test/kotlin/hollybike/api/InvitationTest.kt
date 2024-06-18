package hollybike.api

import hollybike.api.base.IntegrationSpec
import hollybike.api.base.auth
import hollybike.api.stores.UserStore
import hollybike.api.types.association.EAssociationsStatus
import hollybike.api.types.association.TAssociation
import hollybike.api.types.invitation.EInvitationStatus
import hollybike.api.types.invitation.TInvitation
import hollybike.api.types.invitation.TInvitationCreation
import hollybike.api.types.lists.TLists
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
								association = TAssociation(0, "", EAssociationsStatus.Enabled, ""),
								status = EInvitationStatus.Enabled
							),
							TInvitation::link,
							TInvitation::creation,
							TInvitation::association
						)
					}
				}
			}
		}

		test("Should not create the invitation link because the user is not an admin") {
			onPremiseTestApp {
				it.post("/api/invitation") {
					auth(UserStore.user1)
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
				}.apply {
					status shouldBe HttpStatusCode.NotFound
					bodyAsText() shouldBe "Invitation inconnue"
				}
			}
		}

		test("Should not disable the invitation because the user is not an admin") {
			onPremiseTestApp {
				val invitation = generateInvitation(it, UserStore.admin1)

				it.patch("/api/invitation/${invitation["invitation"]!!.toInt()}/disable") {
					auth(UserStore.user1)
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
					auth(UserStore.root)
				}.apply {
					status shouldBe HttpStatusCode.OK

					body<TLists<TInvitation>>() shouldBe TLists(emptyList(), 0, 0, 20, 0)
				}
			}
		}

		test("Should not return the list of invitations because the user is not a root") {
			onPremiseTestApp {
				it.get("/api/invitation") {
					auth(UserStore.user1)
				}.apply {
					status shouldBe HttpStatusCode.Forbidden

					bodyAsText() shouldBe "You don't have sufficient permissions to access this resource"
				}
			}
		}

		test("Should return list of invitations with links") {
			onPremiseTestApp {
				generateInvitation(it, UserStore.root)

				it.get("/api/invitation") {
					auth(UserStore.root)
				}.apply {
					status shouldBe HttpStatusCode.OK
					body<TLists<TInvitation>>().let { body ->
						body.totalData shouldBe 1
						body.data.size shouldBe 1

						body.data.forEach { invitation ->
							invitation.link shouldNotBe null
						}
					}
				}
			}
		}

		test("Should return list of disabled invitations without links") {
			onPremiseTestApp {
				generateInvitation(it, UserStore.root, disabled = true)

				it.get("/api/invitation") {
					auth(UserStore.root)
				}.apply {
					status shouldBe HttpStatusCode.OK

					body<TLists<TInvitation>>().totalData shouldBe 1
					body<TLists<TInvitation>>().data.size shouldBe 1

					body<TLists<TInvitation>>().data.forEach { invitation ->
						invitation.link shouldBe null
					}
				}
			}
		}
	}
})