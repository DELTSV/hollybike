package hollybike.api

import hollybike.api.base.IntegrationSpec
import hollybike.api.services.storage.StorageMode
import hollybike.api.types.association.TAssociation
import hollybike.api.types.event.*
import hollybike.api.types.lists.TLists
import io.kotest.matchers.collections.shouldContain
import io.kotest.matchers.collections.shouldNotContain
import io.kotest.matchers.equality.shouldBeEqualToIgnoringFields
import io.kotest.matchers.shouldBe
import io.ktor.client.call.*
import io.ktor.client.request.*
import io.ktor.client.request.forms.*
import io.ktor.client.statement.*
import io.ktor.http.*
import kotlinx.datetime.*
import java.io.File

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
		test("Should get all the events of the database as root user") {
			onPremiseTestApp {
				it.get("/api/events?page=0&per_page=10&sort=start_date_time.ASC") {
					header("Authorization", "Bearer ${tokenStore.get("root@hollybike.fr")}")
				}.apply {
					status shouldBe HttpStatusCode.OK

					val body = body<TLists<TEventPartial>>()

					body.shouldBeEqualToIgnoringFields(
						TLists(
							data = listOf(),
							page = 0,
							totalPage = 2,
							perPage = 10,
							totalData = 11
						),
						TLists<TAssociation>::data
					)

					body.data.size shouldBe 10

					body.data.map { event -> event.status } shouldContain EEventStatus.PENDING
				}
			}
		}

		test("Should only the events of the association 1 as root user") {
			onPremiseTestApp {
				it.get("/api/events?page=0&per_page=10&sort=start_date_time.ASC&id_association=eq:2") {
					header("Authorization", "Bearer ${tokenStore.get("root@hollybike.fr")}")
				}.apply {
					status shouldBe HttpStatusCode.OK

					val body = body<TLists<TEventPartial>>()

					body.shouldBeEqualToIgnoringFields(
						TLists(
							data = listOf(),
							page = 0,
							totalPage = 1,
							perPage = 10,
							totalData = 6
						),
						TLists<TAssociation>::data
					)

					body.data.size shouldBe 6

					body.data.map { event -> event.status } shouldContain EEventStatus.PENDING
				}
			}
		}

		test("Should get all the scheduled events of the association") {
			onPremiseTestApp {
				it.get("/api/events?page=0&per_page=10&sort=start_date_time.ASC") {
					header("Authorization", "Bearer ${tokenStore.get("user3@hollybike.fr")}")
				}.apply {
					status shouldBe HttpStatusCode.OK

					val body = body<TLists<TEventPartial>>()

					body.shouldBeEqualToIgnoringFields(
						TLists(
							data = listOf(),
							page = 0,
							totalPage = 1,
							perPage = 10,
							totalData = 4
						),
						TLists<TAssociation>::data
					)

					body.data.size shouldBe 4

					body.data.map { event -> event.status } shouldNotContain EEventStatus.PENDING
				}
			}
		}

		test("Should get all the scheduled events of the association and my pending events") {
			onPremiseTestApp {
				it.get("/api/events?page=0&per_page=10&sort=start_date_time.ASC") {
					header("Authorization", "Bearer ${tokenStore.get("user4@hollybike.fr")}")
				}.apply {
					status shouldBe HttpStatusCode.OK

					val body = body<TLists<TEventPartial>>()

					body.shouldBeEqualToIgnoringFields(
						TLists(
							data = listOf(),
							page = 0,
							totalPage = 1,
							perPage = 10,
							totalData = 5
						),
						TLists<TAssociation>::data
					)

					body.data.size shouldBe 5

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

	context("Schedule event") {
		test("Should schedule pending event") {
			onPremiseTestApp {
				it.patch("/api/events/1/schedule") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.OK
				}
			}
		}

		test("Should not schedule the already scheduled event") {
			onPremiseTestApp {
				it.patch("/api/events/2/schedule") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.Forbidden

					bodyAsText() shouldBe "Event déjà scheduled"
				}
			}
		}

		test("Should not schedule event because it does not exist") {
			onPremiseTestApp {
				it.patch("/api/events/20/schedule") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.NotFound

					bodyAsText() shouldBe "Event 20 introuvable"
				}
			}
		}

		test("Should not schedule event if the user is not participating") {
			onPremiseTestApp {
				it.patch("/api/events/6/schedule") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.Forbidden

					bodyAsText() shouldBe "Vous ne participez pas à cet événement"
				}
			}
		}

		test("Should not update an event if the user is not an organizer") {
			onPremiseTestApp {
				it.patch("/api/events/2/schedule") {
					header("Authorization", "Bearer ${tokenStore.get("user2@hollybike.fr")}")
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.Forbidden

					bodyAsText() shouldBe "Seul l'organisateur peut modifier le statut de l'événement"
				}
			}
		}
	}

	context("Cancel event") {
		test("Should cancel the scheduled event") {
			onPremiseTestApp {
				it.patch("/api/events/2/cancel") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.OK
				}
			}
		}

		test("Should not cancel the pending event") {
			onPremiseTestApp {
				it.patch("/api/events/1/cancel") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.Forbidden

					bodyAsText() shouldBe "Seul un événement planifié peut être annulé"
				}
			}
		}

		test("Should not cancel the already canceled event") {
			onPremiseTestApp {
				it.patch("/api/events/3/cancel") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.Forbidden

					bodyAsText() shouldBe "Event déjà cancelled"
				}
			}
		}

		test("Should not cancel the terminated event") {
			onPremiseTestApp {
				it.patch("/api/events/4/cancel") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.Forbidden

					bodyAsText() shouldBe "Seul un événement planifié peut être annulé"
				}
			}
		}

		test("Should not cancel event because it does not exist") {
			onPremiseTestApp {
				it.patch("/api/events/20/cancel") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.NotFound

					bodyAsText() shouldBe "Event 20 introuvable"
				}
			}
		}

		test("Should not cancel event if the user is not participating") {
			onPremiseTestApp {
				it.patch("/api/events/6/cancel") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.Forbidden

					bodyAsText() shouldBe "Vous ne participez pas à cet événement"
				}
			}
		}

		test("Should not cancel event if the user is not an organizer") {
			onPremiseTestApp {
				it.patch("/api/events/2/cancel") {
					header("Authorization", "Bearer ${tokenStore.get("user2@hollybike.fr")}")
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.Forbidden

					bodyAsText() shouldBe "Seul l'organisateur peut modifier le statut de l'événement"
				}
			}
		}
	}

	context("Pend event") {
		test("Should pend the scheduled event") {
			onPremiseTestApp {
				it.patch("/api/events/2/pend") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.OK
				}
			}
		}

		test("Should not pend the already pending event") {
			onPremiseTestApp {
				it.patch("/api/events/1/pend") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.Forbidden

					bodyAsText() shouldBe "Event déjà pending"
				}
			}
		}

		test("Should not pend event because it does not exist") {
			onPremiseTestApp {
				it.patch("/api/events/20/pend") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.NotFound

					bodyAsText() shouldBe "Event 20 introuvable"
				}
			}
		}

		test("Should not pend event if the user is not participating") {
			onPremiseTestApp {
				it.patch("/api/events/6/pend") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.Forbidden

					bodyAsText() shouldBe "Vous ne participez pas à cet événement"
				}
			}
		}

		test("Should not pend event if the user is not an organizer") {
			onPremiseTestApp {
				it.patch("/api/events/2/pend") {
					header("Authorization", "Bearer ${tokenStore.get("user2@hollybike.fr")}")
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.Forbidden

					bodyAsText() shouldBe "Seul l'organisateur peut modifier le statut de l'événement"
				}
			}
		}

		test("Should not pend event if the user is not an organizer") {
			onPremiseTestApp {
				it.patch("/api/events/2/pend") {
					header("Authorization", "Bearer ${tokenStore.get("user2@hollybike.fr")}")
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.Forbidden

					bodyAsText() shouldBe "Seul l'organisateur peut modifier le statut de l'événement"
				}
			}
		}

		test("Should not pend event if the user is not the owner") {
			onPremiseTestApp {
				it.patch("/api/events/7/pend") {
					header("Authorization", "Bearer ${tokenStore.get("user4@hollybike.fr")}")
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.Forbidden

					bodyAsText() shouldBe "Seul le propriétaire peut mettre l'événement en attente"
				}
			}
		}
	}

	context("Finish event") {
		test("Should finish the scheduled event") {
			onPremiseTestApp {
				it.patch("/api/events/2/finish") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.OK
				}
			}
		}

		test("Should not finish the already finished event") {
			onPremiseTestApp {
				it.patch("/api/events/4/finish") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.Forbidden

					bodyAsText() shouldBe "Event déjà finished"
				}
			}
		}

		test("Should not finish the pending event") {
			onPremiseTestApp {
				it.patch("/api/events/1/finish") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.Forbidden

					bodyAsText() shouldBe "Seul un événement planifié peut être terminé"
				}
			}
		}

		test("Should not finish the canceled event") {
			onPremiseTestApp {
				it.patch("/api/events/3/finish") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.Forbidden

					bodyAsText() shouldBe "Seul un événement planifié peut être terminé"
				}
			}
		}

		test("Should not finish event because it does not exist") {
			onPremiseTestApp {
				it.patch("/api/events/20/finish") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.NotFound

					bodyAsText() shouldBe "Event 20 introuvable"
				}
			}
		}

		test("Should not finish event if the user is not participating") {
			onPremiseTestApp {
				it.patch("/api/events/6/finish") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.Forbidden

					bodyAsText() shouldBe "Vous ne participez pas à cet événement"
				}
			}
		}

		test("Should not finish event if the user is not an organizer") {
			onPremiseTestApp {
				it.patch("/api/events/2/finish") {
					header("Authorization", "Bearer ${tokenStore.get("user2@hollybike.fr")}")
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.Forbidden

					bodyAsText() shouldBe "Seul l'organisateur peut modifier le statut de l'événement"
				}
			}
		}

		test("Should not finish event if the user is not an organizer") {
			onPremiseTestApp {
				it.patch("/api/events/2/finish") {
					header("Authorization", "Bearer ${tokenStore.get("user2@hollybike.fr")}")
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.Forbidden

					bodyAsText() shouldBe "Seul l'organisateur peut modifier le statut de l'événement"
				}
			}
		}
	}

	context("Upload event picture") {
		listOf(
			"image/jpeg",
			"image/png"
		).forEach { contentType ->
			listOf(
				StorageMode.S3,
				StorageMode.LOCAL,
				StorageMode.FTP
			).forEach { storageMode ->
				test("Should upload event $contentType picture with $storageMode storage mode") {
					onPremiseTestApp(storageMode) {
						val file = File(
							javaClass.classLoader.getResource("profile.jpg")?.file ?: error("File profile.jpg not found")
						)

						it.patch("/api/events/1/image") {
							val boundary = "WebAppBoundary"
							header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
							setBody(
								MultiPartFormDataContent(
									formData {
										append("file", file.readBytes(), Headers.build {
											append(HttpHeaders.ContentType, contentType)
											append(HttpHeaders.ContentDisposition, "filename=\"profile.jpg\"")
										})
									},
									boundary,
									ContentType.MultiPart.FormData.withParameter("boundary", boundary)
								)
							)
						}.apply {
							status shouldBe HttpStatusCode.OK
						}
					}
				}
			}
		}

		listOf(
			"image/gif",
			"image/svg+xml",
			"image/webp",
			"application/javascript",
		).forEach { contentType ->
			test("Should not upload event $contentType picture") {
				onPremiseTestApp {
					val file = File(
						javaClass.classLoader.getResource("profile.jpg")?.file ?: error("File profile.jpg not found")
					)

					it.patch("/api/events/1/image") {
						val boundary = "WebAppBoundary"
						header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
						setBody(
							MultiPartFormDataContent(
								formData {
									append("file", file.readBytes(), Headers.build {
										append(HttpHeaders.ContentType, contentType)
										append(HttpHeaders.ContentDisposition, "filename=\"profile.jpg\"")
									})
								},
								boundary,
								ContentType.MultiPart.FormData.withParameter("boundary", boundary)
							)
						)
					}.apply {
						status shouldBe HttpStatusCode.BadRequest

						bodyAsText() shouldBe "Image invalide (JPEG et PNG seulement)"
					}
				}
			}
		}

		test("Should not upload event picture without content type") {
			onPremiseTestApp {
				val file = File(
					javaClass.classLoader.getResource("profile.jpg")?.file ?: error("File profile.jpg not found")
				)

				it.patch("/api/events/1/image") {
					val boundary = "WebAppBoundary"
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
					setBody(
						MultiPartFormDataContent(
							formData {
								append("file", file.readBytes(), Headers.build {
									append(HttpHeaders.ContentDisposition, "filename=\"profile.jpg\"")
								})
							},
							boundary,
							ContentType.MultiPart.FormData.withParameter("boundary", boundary)
						)
					)
				}.apply {
					status shouldBe HttpStatusCode.BadRequest

					bodyAsText() shouldBe "Type de contenu de l'image manquant"
				}
			}
		}

		test("Should not upload event picture if the user is not organizer") {
			onPremiseTestApp {
				val file = File(
					javaClass.classLoader.getResource("profile.jpg")?.file ?: error("File profile.jpg not found")
				)

				it.patch("/api/events/2/image") {
					val boundary = "WebAppBoundary"
					header("Authorization", "Bearer ${tokenStore.get("user2@hollybike.fr")}")
					setBody(
						MultiPartFormDataContent(
							formData {
								append("file", file.readBytes(), Headers.build {
									append(HttpHeaders.ContentType, "image/jpeg")
									append(HttpHeaders.ContentDisposition, "filename=\"profile.jpg\"")
								})
							},
							boundary,
							ContentType.MultiPart.FormData.withParameter("boundary", boundary)
						)
					)
				}.apply {
					status shouldBe HttpStatusCode.Forbidden

					bodyAsText() shouldBe "Seul l'organisateur peut modifier l'événement"
				}
			}
		}

		test("Should not upload event picture if the user is not participating") {
			onPremiseTestApp {
				val file = File(
					javaClass.classLoader.getResource("profile.jpg")?.file ?: error("File profile.jpg not found")
				)

				it.patch("/api/events/6/image") {
					val boundary = "WebAppBoundary"
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
					setBody(
						MultiPartFormDataContent(
							formData {
								append("file", file.readBytes(), Headers.build {
									append(HttpHeaders.ContentType, "image/jpeg")
									append(HttpHeaders.ContentDisposition, "filename=\"profile.jpg\"")
								})
							},
							boundary,
							ContentType.MultiPart.FormData.withParameter("boundary", boundary)
						)
					)
				}.apply {
					status shouldBe HttpStatusCode.Forbidden

					bodyAsText() shouldBe "Vous ne participez pas à cet événement"
				}
			}
		}

		test("Should not upload event picture if the event does not exist") {
			onPremiseTestApp {
				val file = File(
					javaClass.classLoader.getResource("profile.jpg")?.file ?: error("File profile.jpg not found")
				)

				it.patch("/api/events/20/image") {
					val boundary = "WebAppBoundary"
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
					setBody(
						MultiPartFormDataContent(
							formData {
								append("file", file.readBytes(), Headers.build {
									append(HttpHeaders.ContentType, "image/jpeg")
									append(HttpHeaders.ContentDisposition, "filename=\"profile.jpg\"")
								})
							},
							boundary,
							ContentType.MultiPart.FormData.withParameter("boundary", boundary)
						)
					)
				}.apply {
					status shouldBe HttpStatusCode.NotFound

					bodyAsText() shouldBe "Event 20 introuvable"
				}
			}
		}
	}

	context("Participate event") {
		test("Should participate to the event") {
			onPremiseTestApp {
				it.post("/api/events/6/participations") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.Created

					body<TEventParticipation>().role shouldBe EEventRole.MEMBER
				}
			}
		}

		test("Should not participate to the event because you are already participating") {
			onPremiseTestApp {
				it.post("/api/events/1/participations") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.Conflict

					bodyAsText() shouldBe "Vous participez déjà à cet événement"
				}
			}
		}

		test("Should not participate to the event because it does not exist") {
			onPremiseTestApp {
				it.post("/api/events/20/participations") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.NotFound

					bodyAsText() shouldBe "Event 20 introuvable"
				}
			}
		}

		test("Should not participate to the event because you are not in the same association") {
			onPremiseTestApp {
				it.post("/api/events/8/participations") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
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
				it.delete("/api/events/2/participations") {
					header("Authorization", "Bearer ${tokenStore.get("user2@hollybike.fr")}")
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.OK
				}
			}
		}

		test("Should not leave the event because you are the owner") {
			onPremiseTestApp {
				it.delete("/api/events/1/participations") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.Forbidden

					bodyAsText() shouldBe "Le propriétaire ne peut pas quitter l'événement"
				}
			}
		}

		test("Should not leave the event because it does not exist") {
			onPremiseTestApp {
				it.delete("/api/events/20/participations") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.NotFound

					bodyAsText() shouldBe "Event 20 introuvable"
				}
			}
		}

		test("Should not leave the event because you are not participating") {
			onPremiseTestApp {
				it.delete("/api/events/9/participations") {
					header("Authorization", "Bearer ${tokenStore.get("user3@hollybike.fr")}")
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.NotFound

					bodyAsText() shouldBe "Vous ne participez pas à cet événement"
				}
			}
		}
	}

	context("Promote event participant") {
		test("Should promote the participant") {
			onPremiseTestApp {
				it.patch("/api/events/2/participations/3/promote") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.OK

					body<TEventParticipation>().role shouldBe EEventRole.ORGANIZER
				}
			}
		}

		test("Should not promote the participant because the event does not exist") {
			onPremiseTestApp {
				it.patch("/api/events/20/participations/3/promote") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.NotFound

					bodyAsText() shouldBe "Event 20 introuvable"
				}
			}
		}

		test("Should not promote the participant because you are not organizer") {
			onPremiseTestApp {
				it.patch("/api/events/10/participations/6/promote") {
					header("Authorization", "Bearer ${tokenStore.get("user3@hollybike.fr")}")
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.Forbidden

					bodyAsText() shouldBe "Seul l'organisateur peut promouvoir un participant"
				}
			}
		}

		test("Should not promote yourself") {
			onPremiseTestApp {
				it.patch("/api/events/2/participations/2/promote") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.Forbidden

					bodyAsText() shouldBe "Vous ne pouvez pas vous promouvoir"
				}
			}
		}

		test("Should not promote the participant because he is not participating") {
			onPremiseTestApp {
				it.patch("/api/events/9/participations/4/promote") {
					header("Authorization", "Bearer ${tokenStore.get("user4@hollybike.fr")}")
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.NotFound

					bodyAsText() shouldBe "L'utilisateur ne participe pas à cet événement"
				}
			}
		}

		test("Should not promote the participant because the user is already organizer") {
			onPremiseTestApp {
				it.patch("/api/events/11/participations/4/promote") {
					header("Authorization", "Bearer ${tokenStore.get("user4@hollybike.fr")}")
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
				it.patch("/api/events/7/participations/5/demote") {
					header("Authorization", "Bearer ${tokenStore.get("user3@hollybike.fr")}")
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.OK

					body<TEventParticipation>().role shouldBe EEventRole.MEMBER
				}
			}
		}

		test("Should not demote the participant because the event does not exist") {
			onPremiseTestApp {
				it.patch("/api/events/20/participations/5/demote") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.NotFound

					bodyAsText() shouldBe "Event 20 introuvable"
				}
			}
		}

		test("Should not demote the participant because you are not organizer") {
			onPremiseTestApp {
				it.patch("/api/events/2/participations/2/demote") {
					header("Authorization", "Bearer ${tokenStore.get("user2@hollybike.fr")}")
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.Forbidden

					bodyAsText() shouldBe "Seul l'organisateur peut rétrograder un participant"
				}
			}
		}

		test("Should not demote yourself") {
			onPremiseTestApp {
				it.patch("/api/events/1/participations/2/demote") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.Forbidden

					bodyAsText() shouldBe "Vous ne pouvez pas vous rétrograder"
				}
			}
		}

		test("Should not demote the participant because he is not participating") {
			onPremiseTestApp {
				it.patch("/api/events/9/participations/4/demote") {
					header("Authorization", "Bearer ${tokenStore.get("user4@hollybike.fr")}")
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.NotFound

					bodyAsText() shouldBe "L'utilisateur ne participe pas à cet événement"
				}
			}
		}

		test("Should not promote the participant because the user is already member") {
			onPremiseTestApp {
				it.patch("/api/events/2/participations/3/demote") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.Forbidden

					bodyAsText() shouldBe "Seul un organisateur peut être rétrogradé"
				}
			}
		}
	}

	context("Delete event") {
		test("Should delete the event") {
			onPremiseTestApp {
				it.delete("/api/events/1") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.OK
				}
			}
		}

		test("Should not delete the event because im not the owner") {
			onPremiseTestApp {
				it.delete("/api/events/6") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.Forbidden

					bodyAsText() shouldBe "Seul le propriétaire peut supprimer l'événement"
				}
			}
		}

		test("Should not delete the event because it does not exist") {
			onPremiseTestApp {
				it.delete("/api/events/20") {
					header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.NotFound

					bodyAsText() shouldBe "Event 20 introuvable"
				}
			}
		}
	}
})

private fun s() = "of"