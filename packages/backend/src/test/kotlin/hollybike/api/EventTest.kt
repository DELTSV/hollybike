package hollybike.api

import hollybike.api.base.IntegrationSpec
import hollybike.api.types.association.TAssociation
import hollybike.api.types.event.*
import hollybike.api.types.lists.TLists
import io.kotest.matchers.collections.shouldContain
import io.kotest.matchers.collections.shouldNotContain
import io.kotest.matchers.equality.shouldBeEqualToIgnoringFields
import io.kotest.matchers.shouldBe
import io.ktor.client.call.*
import io.ktor.client.request.*
import io.ktor.client.statement.*
import io.ktor.http.*
import kotlinx.datetime.*

class EventTest : IntegrationSpec({
	val workingCreateDate = Clock.System.now().plus(
		DateTimePeriod(months = 1),
		TimeZone.currentSystemDefault()
	)

	val workingEndDate = workingCreateDate.plus(
		DateTimePeriod(days = 1),
		TimeZone.currentSystemDefault()
	)

	context("Get all events") {
		test("Should get all the scheduled events of the association") {
			onPremiseTestApp {
				it.get("/api/events") {
					header("Authorization", "Bearer ${tokenStore.get("user3@hollybike.fr")}")
				}.apply {
					status shouldBe HttpStatusCode.OK

					val body = body<TLists<TEventPartial>>()

					body.shouldBeEqualToIgnoringFields(
						TLists(
							data = listOf(),
							page = 0,
							totalPage = 1,
							perPage = 20,
							totalData = 2
						),
						TLists<TAssociation>::data
					)

					body.data.size shouldBe 2

					body.data.map { event -> event.status } shouldNotContain EEventStatus.PENDING
				}
			}
		}

		test("Should get all the scheduled events of the association and my pending events") {
			onPremiseTestApp {
				it.get("/api/events") {
					header("Authorization", "Bearer ${tokenStore.get("user4@hollybike.fr")}")
				}.apply {
					status shouldBe HttpStatusCode.OK

					val body = body<TLists<TEventPartial>>()

					body.shouldBeEqualToIgnoringFields(
						TLists(
							data = listOf(),
							page = 0,
							totalPage = 1,
							perPage = 20,
							totalData = 3
						),
						TLists<TAssociation>::data
					)

					body.data.size shouldBe 3

					body.data.map { event -> event.status } shouldContain EEventStatus.PENDING
				}
			}
		}
	}

	context("Get event by id") {
		test("Should get the event by id") {
			onPremiseTestApp {
				it.get("/api/events/2") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
				}.apply {
					status shouldBe HttpStatusCode.OK

					body<TEvent>().name shouldBe "Event 2 - Asso 1 - User 1 - SCHEDULED"
				}
			}
		}

		test("Should get the event by id with pending status because the user is the owner") {
			onPremiseTestApp {
				it.get("/api/events/1") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
				}.apply {
					status shouldBe HttpStatusCode.OK

					body<TEvent>().name shouldBe "Event 1 - Asso 1 - User 1 - PENDING"
				}
			}
		}

		test("Should not get the event by id because the user is not the owner and the status is PENDING") {
			onPremiseTestApp {
				it.get("/api/events/1") {
					header("Authorization", "Bearer ${tokenStore.get("user2@hollybike.fr")}")
				}.apply {
					status shouldBe HttpStatusCode.NotFound

					bodyAsText() shouldBe "Event not found"
				}
			}
		}

		test("Should not get the event by id because im not in the association") {
			onPremiseTestApp {
				it.get("/api/events/2") {
					header("Authorization", "Bearer ${tokenStore.get("user4@hollybike.fr")}")
				}.apply {
					status shouldBe HttpStatusCode.NotFound

					bodyAsText() shouldBe "Event not found"
				}
			}
		}
	}

	context("Create event") {
		listOf(
			TCreateEvent(
				name = "New Event",
				description = "New Event Description",
				startDate = workingCreateDate.toString(),
				endDate = workingEndDate.toString()
			),
			TCreateEvent(
				name = "New Event",
				description = null,
				startDate = workingCreateDate.toString(),
				endDate = workingEndDate.toString()
			),
			TCreateEvent(
				name = "New Event",
				description = "New Event Description",
				startDate = workingCreateDate.toString(),
				endDate = null
			)
		).forEach { newEvent ->
			test("Should create an event with one participant (organizer)") {
				onPremiseTestApp {
					it.post("/api/events") {
						header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
						contentType(ContentType.Application.Json)
						setBody(newEvent)
					}.apply {
						status shouldBe HttpStatusCode.Created

						body<TEvent>().status shouldBe EEventStatus.PENDING

						body<TEvent>().participants.size shouldBe 1

						body<TEvent>().participants[0].user.username shouldBe "user1"
						body<TEvent>().participants[0].role shouldBe EEventRole.ORGANIZER
					}
				}
			}
		}

		test("Should not create an event because the start date is in the past") {
			onPremiseTestApp {
				it.post("/api/events") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
					contentType(ContentType.Application.Json)
					setBody(
						TCreateEvent(
							name = "New Event",
							description = "New Event Description",
							startDate = Clock.System.now().minus(
								DateTimePeriod(days = 1),
								TimeZone.currentSystemDefault()
							).toString(),
							endDate = null
						)
					)
				}.apply {
					status shouldBe HttpStatusCode.BadRequest

					bodyAsText() shouldBe "La date de début doit être dans le futur"
				}
			}
		}

		test("Should not create an event because the start date is after the end date") {
			onPremiseTestApp {
				it.post("/api/events") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
					contentType(ContentType.Application.Json)
					setBody(
						TCreateEvent(
							name = "New Event",
							description = "New Event Description",
							startDate = workingCreateDate.toString(),
							endDate = workingCreateDate.minus(
								DateTimePeriod(days = 1),
								TimeZone.currentSystemDefault()
							).toString()
						)
					)
				}.apply {
					status shouldBe HttpStatusCode.BadRequest

					bodyAsText() shouldBe "La date de fin doit être après la date de début"
				}
			}
		}

		test("Should not create an event because the start date is malformed") {
			onPremiseTestApp {
				it.post("/api/events") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
					contentType(ContentType.Application.Json)
					setBody(
						TCreateEvent(
							name = "New Event",
							description = "New Event Description",
							startDate = "malformed",
							endDate = null
						)
					)
				}.apply {
					status shouldBe HttpStatusCode.BadRequest

					bodyAsText() shouldBe "Format de la date de début invalide"
				}
			}
		}

		test("Should not create an event because the end date is malformed") {
			onPremiseTestApp {
				it.post("/api/events") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
					contentType(ContentType.Application.Json)
					setBody(
						TCreateEvent(
							name = "New Event",
							description = "New Event Description",
							startDate = workingCreateDate.toString(),
							endDate = "malformed"
						)
					)
				}.apply {
					status shouldBe HttpStatusCode.BadRequest

					bodyAsText() shouldBe "Format de la date de fin invalide"
				}
			}
		}

		test("Should not create an event because name is too long") {
			onPremiseTestApp {
				it.post("/api/events") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
					contentType(ContentType.Application.Json)
					setBody(
						TCreateEvent(
							name = "a".repeat(101),
							description = "New Event Description",
							startDate = workingCreateDate.toString(),
							endDate = null
						)
					)
				}.apply {
					status shouldBe HttpStatusCode.BadRequest

					bodyAsText() shouldBe "Le nom de l'événement ne peut pas dépasser 100 caractères"
				}
			}
		}

		test("Should not create an event because name is provided but empty") {
			onPremiseTestApp {
				it.post("/api/events") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
					contentType(ContentType.Application.Json)
					setBody(
						TCreateEvent(
							name = "",
							description = "New Event Description",
							startDate = workingCreateDate.toString(),
							endDate = null
						)
					)
				}.apply {
					status shouldBe HttpStatusCode.BadRequest

					bodyAsText() shouldBe "Le nom de l'événement ne peut pas être vide"
				}
			}
		}

		test("Should not create an event because description is too long") {
			onPremiseTestApp {
				it.post("/api/events") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
					contentType(ContentType.Application.Json)
					setBody(
						TCreateEvent(
							name = "New Event",
							description = "a".repeat(1001),
							startDate = workingCreateDate.toString(),
							endDate = null
						)
					)
				}.apply {
					status shouldBe HttpStatusCode.BadRequest

					bodyAsText() shouldBe "La description de l'événement ne peut pas dépasser 1000 caractères"
				}
			}
		}

		test("Should not create an event because description is provided but empty") {
			onPremiseTestApp {
				it.post("/api/events") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
					contentType(ContentType.Application.Json)
					setBody(
						TCreateEvent(
							name = "New Event",
							description = "",
							startDate = workingCreateDate.toString(),
							endDate = null
						)
					)
				}.apply {
					status shouldBe HttpStatusCode.BadRequest

					bodyAsText() shouldBe "La description de l'événement ne peut pas être vide"
				}
			}
		}
	}

	context("Update event") {
		listOf(
			TUpdateEvent(
				name = "Updated Event",
				description = "New Event Description",
				startDate = workingCreateDate.toString(),
				endDate = workingEndDate.toString()
			),
			TUpdateEvent(
				name = "Updated Event",
				description = null,
				startDate = workingCreateDate.toString(),
				endDate = workingEndDate.toString()
			),
			TUpdateEvent(
				name = "Updated Event",
				description = "New Event Description",
				startDate = workingCreateDate.toString(),
				endDate = null
			)
		).forEach { newEvent ->
			test("Should update an event") {
				onPremiseTestApp {
					it.put("/api/events/1") {
						header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
						contentType(ContentType.Application.Json)
						setBody(newEvent)
					}.apply {
						status shouldBe HttpStatusCode.OK

						body<TEvent>().name shouldBe "Updated Event"
					}
				}
			}
		}

		test("Should not update an event because the start date is in the past") {
			onPremiseTestApp {
				it.put("/api/events/1") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
					contentType(ContentType.Application.Json)
					setBody(
						TUpdateEvent(
							name = "New Event",
							description = "New Event Description",
							startDate = Clock.System.now().minus(
								DateTimePeriod(days = 1),
								TimeZone.currentSystemDefault()
							).toString(),
							endDate = null
						)
					)
				}.apply {
					status shouldBe HttpStatusCode.BadRequest

					bodyAsText() shouldBe "La date de début doit être dans le futur"
				}
			}
		}

		test("Should not update an event because the start date is after the end date") {
			onPremiseTestApp {
				it.put("/api/events/1") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
					contentType(ContentType.Application.Json)
					setBody(
						TUpdateEvent(
							name = "New Event",
							description = "New Event Description",
							startDate = workingCreateDate.toString(),
							endDate = workingCreateDate.minus(
								DateTimePeriod(days = 1),
								TimeZone.currentSystemDefault()
							).toString()
						)
					)
				}.apply {
					status shouldBe HttpStatusCode.BadRequest

					bodyAsText() shouldBe "La date de fin doit être après la date de début"
				}
			}
		}

		test("Should not update an event because the start date is malformed") {
			onPremiseTestApp {
				it.put("/api/events/1") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
					contentType(ContentType.Application.Json)
					setBody(
						TUpdateEvent(
							name = "New Event",
							description = "New Event Description",
							startDate = "malformed",
							endDate = null
						)
					)
				}.apply {
					status shouldBe HttpStatusCode.BadRequest

					bodyAsText() shouldBe "Format de la date de début invalide"
				}
			}
		}

		test("Should not update an event because the end date is malformed") {
			onPremiseTestApp {
				it.put("/api/events/1") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
					contentType(ContentType.Application.Json)
					setBody(
						TUpdateEvent(
							name = "New Event",
							description = "New Event Description",
							startDate = workingCreateDate.toString(),
							endDate = "malformed"
						)
					)
				}.apply {
					status shouldBe HttpStatusCode.BadRequest

					bodyAsText() shouldBe "Format de la date de fin invalide"
				}
			}
		}

		test("Should not update an event because name is too long") {
			onPremiseTestApp {
				it.put("/api/events/1") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
					contentType(ContentType.Application.Json)
					setBody(
						TUpdateEvent(
							name = "a".repeat(101),
							description = "New Event Description",
							startDate = workingCreateDate.toString(),
							endDate = null
						)
					)
				}.apply {
					status shouldBe HttpStatusCode.BadRequest

					bodyAsText() shouldBe "Le nom de l'événement ne peut pas dépasser 100 caractères"
				}
			}
		}

		test("Should not update an event because name is provided but empty") {
			onPremiseTestApp {
				it.put("/api/events/1") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
					contentType(ContentType.Application.Json)
					setBody(
						TUpdateEvent(
							name = "",
							description = "New Event Description",
							startDate = workingCreateDate.toString(),
							endDate = null
						)
					)
				}.apply {
					status shouldBe HttpStatusCode.BadRequest

					bodyAsText() shouldBe "Le nom de l'événement ne peut pas être vide"
				}
			}
		}

		test("Should not update an event because description is too long") {
			onPremiseTestApp {
				it.put("/api/events/1") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
					contentType(ContentType.Application.Json)
					setBody(
						TUpdateEvent(
							name = "New Event",
							description = "a".repeat(1001),
							startDate = workingCreateDate.toString(),
							endDate = null
						)
					)
				}.apply {
					status shouldBe HttpStatusCode.BadRequest

					bodyAsText() shouldBe "La description de l'événement ne peut pas dépasser 1000 caractères"
				}
			}
		}

		test("Should not update an event because description is provided but empty") {
			onPremiseTestApp {
				it.put("/api/events/1") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
					contentType(ContentType.Application.Json)
					setBody(
						TUpdateEvent(
							name = "New Event",
							description = "",
							startDate = workingCreateDate.toString(),
							endDate = null
						)
					)
				}.apply {
					status shouldBe HttpStatusCode.BadRequest

					bodyAsText() shouldBe "La description de l'événement ne peut pas être vide"
				}
			}
		}

		test("Should not update an event if the user is not an organizer") {
			onPremiseTestApp {
				it.put("/api/events/2") {
					header("Authorization", "Bearer ${tokenStore.get("user2@hollybike.fr")}")
					contentType(ContentType.Application.Json)
					setBody(
						TUpdateEvent(
							name = "New Event",
							description = "New Event Description",
							startDate = workingCreateDate.toString(),
							endDate = null
						)
					)
				}.apply {
					status shouldBe HttpStatusCode.Forbidden

					bodyAsText() shouldBe "Seul l'organisateur peut modifier l'événement"
				}
			}
		}

		test("Should not update an event if the user is not participating") {
			onPremiseTestApp {
				it.put("/api/events/6") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
					contentType(ContentType.Application.Json)
					setBody(
						TUpdateEvent(
							name = "New Event",
							description = "New Event Description",
							startDate = workingCreateDate.toString(),
							endDate = null
						)
					)
				}.apply {
					status shouldBe HttpStatusCode.Forbidden

					bodyAsText() shouldBe "Vous ne participez pas à cet événement"
				}
			}
		}

		test("Should not update an event because it does not exist") {
			onPremiseTestApp {
				it.put("/api/events/20") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
					contentType(ContentType.Application.Json)
					setBody(
						TUpdateEvent(
							name = "New Event",
							description = "New Event Description",
							startDate = workingCreateDate.toString(),
							endDate = null
						)
					)
				}.apply {
					status shouldBe HttpStatusCode.NotFound

					bodyAsText() shouldBe "Event 20 introuvable"
				}
			}
		}
	}
})