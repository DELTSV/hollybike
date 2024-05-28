package hollybike.api

import hollybike.api.base.IntegrationSpec
import hollybike.api.base.auth
import hollybike.api.base.id
import hollybike.api.stores.EventStore
import hollybike.api.stores.UserStore
import hollybike.api.types.event.EEventRole
import hollybike.api.types.event.TEventParticipation
import io.kotest.matchers.shouldBe
import io.ktor.client.call.*
import io.ktor.client.request.*
import io.ktor.client.statement.*
import io.ktor.http.*

class EventParticipationTest : IntegrationSpec({
	context("Promote event participant") {
		test("Should promote the participant") {
			onPremiseTestApp {
				it.patch("/api/events/${EventStore.event2Asso1User1.id}/participations/${UserStore.user2.id}/promote") {
					auth(UserStore.user1)
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.OK

					body<TEventParticipation>().role shouldBe EEventRole.Organizer
				}
			}
		}

		test("Should not promote the participant because the event does not exist") {
			onPremiseTestApp {
				it.patch("/api/events/${EventStore.unknown.id}/participations/${UserStore.user2.id}/promote") {
					auth(UserStore.user1)
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.NotFound

					bodyAsText() shouldBe "Event ${EventStore.unknown.id} introuvable"
				}
			}
		}

		test("Should not promote the participant because you are not organizer") {
			onPremiseTestApp {
				it.patch("/api/events/${EventStore.event4Asso2User4.id}/participations/${UserStore.user5.id}/promote") {
					auth(UserStore.user3)
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.Forbidden

					bodyAsText() shouldBe "Seul l'organisateur peut promouvoir un participant"
				}
			}
		}

		test("Should not promote yourself") {
			onPremiseTestApp {
				it.patch("/api/events/${EventStore.event2Asso1User1.id}/participations/${UserStore.user1.id}/promote") {
					auth(UserStore.user1)
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.Forbidden

					bodyAsText() shouldBe "Vous ne pouvez pas vous promouvoir"
				}
			}
		}

		test("Should not promote the participant because he is not participating") {
			onPremiseTestApp {
				it.patch("/api/events/${EventStore.event3Asso2User4.id}/participations/${UserStore.user3.id}/promote") {
					auth(UserStore.user4)
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.NotFound

					bodyAsText() shouldBe "L'utilisateur ne participe pas à cet événement"
				}
			}
		}

		test("Should not promote the participant because the user is already organizer") {
			onPremiseTestApp {
				it.patch("/api/events/${EventStore.event5Asso2User4.id}/participations/${UserStore.user3.id}/promote") {
					auth(UserStore.user4)
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.Forbidden

					bodyAsText() shouldBe "Seul un membre peut être promu"
				}
			}
		}
	}

	context("Demote event participant") {
		test("Should demote the participant") {
			onPremiseTestApp {
				it.patch("/api/events/${EventStore.event1Asso2User3.id}/participations/${UserStore.user4.id}/demote") {
					auth(UserStore.user3)
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.OK

					body<TEventParticipation>().role shouldBe EEventRole.Member
				}
			}
		}

		test("Should not demote the participant because the event does not exist") {
			onPremiseTestApp {
				it.patch("/api/events/${EventStore.unknown.id}/participations/${UserStore.user4.id}/demote") {
					auth(UserStore.user1)
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.NotFound

					bodyAsText() shouldBe "Event ${EventStore.unknown.id} introuvable"
				}
			}
		}

		test("Should not demote the participant because you are not organizer") {
			onPremiseTestApp {
				it.patch("/api/events/${EventStore.event2Asso1User1.id}/participations/${UserStore.user1.id}/demote") {
					auth(UserStore.user2)
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.Forbidden

					bodyAsText() shouldBe "Seul l'organisateur peut rétrograder un participant"
				}
			}
		}

		test("Should not demote yourself") {
			onPremiseTestApp {
				it.patch("/api/events/${EventStore.event1Asso1User1.id}/participations/${UserStore.user1.id}/demote") {
					auth(UserStore.user1)
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.Forbidden

					bodyAsText() shouldBe "Vous ne pouvez pas vous rétrograder"
				}
			}
		}

		test("Should not demote the participant because he is not participating") {
			onPremiseTestApp {
				it.patch("/api/events/${EventStore.event3Asso2User4.id}/participations/${UserStore.user3.id}/demote") {
					auth(UserStore.user4)
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.NotFound

					bodyAsText() shouldBe "L'utilisateur ne participe pas à cet événement"
				}
			}
		}

		test("Should not promote the participant because the user is already member") {
			onPremiseTestApp {
				it.patch("/api/events/${EventStore.event2Asso1User1.id}/participations/${UserStore.user2.id}/demote") {
					auth(UserStore.user1)
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.Forbidden

					bodyAsText() shouldBe "Seul un organisateur peut être rétrogradé"
				}
			}
		}
	}

	context("Participate event") {
		test("Should participate to the event") {
			onPremiseTestApp {
				it.post("/api/events/${EventStore.event6Asso1User2.id}/participations") {
					auth(UserStore.user1)
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.Created

					body<TEventParticipation>().role shouldBe EEventRole.Member
				}
			}
		}

		test("Should not participate to the event because you are already participating") {
			onPremiseTestApp {
				it.post("/api/events/${EventStore.event1Asso1User1.id}/participations") {
					auth(UserStore.user1)
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.Conflict

					bodyAsText() shouldBe "Vous participez déjà à cet événement"
				}
			}
		}

		test("Should not participate to the event because it does not exist") {
			onPremiseTestApp {
				it.post("/api/events/${EventStore.unknown.id}/participations") {
					auth(UserStore.user1)
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.NotFound

					bodyAsText() shouldBe "Event ${EventStore.unknown.id} introuvable"
				}
			}
		}

		test("Should not participate to the event because you are not in the same association") {
			onPremiseTestApp {
				it.post("/api/events/${EventStore.event2Asso2User4.id}/participations") {
					auth(UserStore.user1)
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.NotFound

					bodyAsText() shouldBe "Event 8 introuvable"
				}
			}
		}
	}

	context("Leave event") {
		test("Should leave the event") {
			onPremiseTestApp {
				it.delete("/api/events/${EventStore.event2Asso1User1.id}/participations") {
					auth(UserStore.user2)
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.OK
				}
			}
		}

		test("Should not leave the event because you are the owner") {
			onPremiseTestApp {
				it.delete("/api/events/${EventStore.event1Asso1User1.id}/participations") {
					auth(UserStore.user1)
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.Forbidden

					bodyAsText() shouldBe "Le propriétaire ne peut pas quitter l'événement"
				}
			}
		}

		test("Should not leave the event because it does not exist") {
			onPremiseTestApp {
				it.delete("/api/events/${EventStore.unknown.id}/participations") {
					auth(UserStore.user1)
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.NotFound

					bodyAsText() shouldBe "Event ${EventStore.unknown.id} introuvable"
				}
			}
		}

		test("Should not leave the event because you are not participating") {
			onPremiseTestApp {
				it.delete("/api/events/${EventStore.event3Asso2User4.id}/participations") {
					auth(UserStore.user3)
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.NotFound

					bodyAsText() shouldBe "Vous ne participez pas à cet événement"
				}
			}
		}
	}
})