/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api

import hollybike.api.base.*
import hollybike.api.services.storage.StorageMode
import hollybike.api.stores.AssociationStore
import hollybike.api.stores.EventStore
import hollybike.api.stores.UserStore
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
					auth(UserStore.root)
				}.apply {
					status shouldBe HttpStatusCode.OK

					val body = body<TLists<TEventPartial>>()

					body.shouldBeEqualToIgnoringFields(
						TLists(
							data = listOf(),
							page = 0,
							totalPage = nbPages(
								pageSize = 10,
								nbItems = EventStore.EVENT_COUNT
							),
							perPage = 10,
							totalData = EventStore.EVENT_COUNT.toLong()
						),
						TLists<TAssociation>::data
					)

					body.data.size shouldBe countWithCap(
						cap = 10,
						count = EventStore.EVENT_COUNT
					)
				}
			}
		}

		test("Should only the events of the association 1 as root user") {
			onPremiseTestApp {
				it.get("/api/events?page=0&per_page=10&sort=start_date_time.ASC&id_association=eq:${AssociationStore.association1.id}") {
					auth(UserStore.root)
				}.apply {
					status shouldBe HttpStatusCode.OK

					val body = body<TLists<TEventPartial>>()

					body.shouldBeEqualToIgnoringFields(
						TLists(
							data = listOf(),
							page = 0,
							totalPage = nbPages(
								pageSize = 10,
								nbItems = EventStore.ASSOCIATION_1_EVENT_COUNT
							),
							perPage = 10,
							totalData = EventStore.ASSOCIATION_1_EVENT_COUNT.toLong()
						),
						TLists<TAssociation>::data
					)

					body.data.size shouldBe countWithCap(
						cap = 10,
						count = EventStore.ASSOCIATION_1_EVENT_COUNT
					)

					body.data.map { event -> event.status } shouldContain EEventStatus.Pending
				}
			}
		}

		test("Should get all the scheduled events of the association") {
			onPremiseTestApp {
				it.get("/api/events?page=0&per_page=10&sort=start_date_time.ASC") {
					auth(UserStore.user3)
				}.apply {
					status shouldBe HttpStatusCode.OK

					val body = body<TLists<TEventPartial>>()

					body.shouldBeEqualToIgnoringFields(
						TLists(
							data = listOf(),
							page = 0,
							totalPage = nbPages(
								pageSize = 10,
								nbItems = EventStore.USER_3_VISIBLE_EVENT_COUNT
							),
							perPage = 10,
							totalData = EventStore.USER_3_VISIBLE_EVENT_COUNT.toLong()
						),
						TLists<TAssociation>::data
					)

					body.data.size shouldBe countWithCap(
						cap = 10,
						count = EventStore.USER_3_VISIBLE_EVENT_COUNT
					)

					body.data.map { event -> event.status } shouldNotContain EEventStatus.Pending
				}
			}
		}

		test("Should get all the scheduled events of the association and my pending events") {
			onPremiseTestApp {
				it.get("/api/events?page=0&per_page=10&sort=start_date_time.ASC") {
					auth(UserStore.user4)
				}.apply {
					status shouldBe HttpStatusCode.OK

					val body = body<TLists<TEventPartial>>()

					body.shouldBeEqualToIgnoringFields(
						TLists(
							data = listOf(),
							page = 0,
							totalPage = nbPages(
								pageSize = 10,
								nbItems = EventStore.USER_4_VISIBLE_EVENT_COUNT
							),
							perPage = 10,
							totalData = EventStore.USER_4_VISIBLE_EVENT_COUNT.toLong()
						),
						TLists<TAssociation>::data
					)

					body.data.size shouldBe countWithCap(
						cap = 10,
						count = EventStore.USER_4_VISIBLE_EVENT_COUNT
					)

					body.data.map { event -> event.status } shouldContain EEventStatus.Pending
				}
			}
		}
	}

	context("Get future events") {
		test("Should all future scheduled events") {
			onPremiseTestApp {
				it.get("/api/events/future?page=0&per_page=10") {
					auth(UserStore.user3)
				}.apply {
					status shouldBe HttpStatusCode.OK

					val body = body<TLists<TEventPartial>>()

					body.shouldBeEqualToIgnoringFields(
						TLists(
							data = listOf(),
							page = 0,
							totalPage = nbPages(
								pageSize = 10,
								nbItems = EventStore.USER_3_VISIBLE_EVENT_COUNT
							),
							perPage = 10,
							totalData = EventStore.USER_3_VISIBLE_EVENT_COUNT.toLong()
						),
						TLists<TAssociation>::data
					)

					body.data.size shouldBe countWithCap(
						cap = 10,
						count = EventStore.USER_3_VISIBLE_EVENT_COUNT
					)
				}
			}
		}

		test("Should all future scheduled and my pending events") {
			onPremiseTestApp {
				it.get("/api/events/future?page=0&per_page=10") {
					auth(UserStore.user4)
				}.apply {
					status shouldBe HttpStatusCode.OK

					val body = body<TLists<TEventPartial>>()

					body.shouldBeEqualToIgnoringFields(
						TLists(
							data = listOf(),
							page = 0,
							totalPage = nbPages(
								pageSize = 10,
								nbItems = EventStore.USER_4_VISIBLE_EVENT_COUNT
							),
							perPage = 10,
							totalData = EventStore.USER_4_VISIBLE_EVENT_COUNT.toLong()
						),
						TLists<TAssociation>::data
					)

					body.data.size shouldBe countWithCap(
						cap = 10,
						count = EventStore.USER_4_VISIBLE_EVENT_COUNT
					)
				}
			}
		}

		test("Should get upcoming & current events and not past events") {
			onPremiseTestApp {
				it.get("/api/events/future?page=0&per_page=10") {
					auth(UserStore.user1)
				}.apply {
					status shouldBe HttpStatusCode.OK

					val body = body<TLists<TEventPartial>>()

					body.shouldBeEqualToIgnoringFields(
						TLists(
							data = listOf(),
							page = 0,
							totalPage = nbPages(
								pageSize = 10,
								nbItems = EventStore.USER_1_FUTURE_EVENT_COUNT
							),
							perPage = 10,
							totalData = EventStore.USER_1_FUTURE_EVENT_COUNT.toLong()
						),
						TLists<TAssociation>::data
					)

					body.data.size shouldBe countWithCap(
						cap = 10,
						count = EventStore.USER_1_FUTURE_EVENT_COUNT
					)
				}
			}
		}
	}

	context("Get archived events") {
		test("Should not have archived events for association 2") {
			onPremiseTestApp {
				it.get("/api/events/archived?page=0&per_page=10") {
					auth(UserStore.user3)
				}.apply {
					status shouldBe HttpStatusCode.OK

					val body = body<TLists<TEventPartial>>()

					body.shouldBeEqualToIgnoringFields(
						TLists(
							data = listOf(),
							page = 0,
							totalPage = 0,
							perPage = 10,
							totalData = 0
						),
						TLists<TAssociation>::data
					)

					body.data.size shouldBe 0
				}
			}
		}

		test("Should all past archived events") {
			onPremiseTestApp {
				it.get("/api/events/archived?page=0&per_page=10") {
					auth(UserStore.user1)
				}.apply {
					status shouldBe HttpStatusCode.OK

					val body = body<TLists<TEventPartial>>()

					body.shouldBeEqualToIgnoringFields(
						TLists(
							data = listOf(),
							page = 0,
							totalPage = nbPages(
								pageSize = 10,
								nbItems = EventStore.ASSOCIATION_1_ARCHIVED_EVENT_COUNT
							),
							perPage = 10,
							totalData = EventStore.ASSOCIATION_1_ARCHIVED_EVENT_COUNT.toLong()
						),
						TLists<TAssociation>::data
					)

					body.data.size shouldBe countWithCap(
						cap = 10,
						count = EventStore.ASSOCIATION_1_ARCHIVED_EVENT_COUNT
					)
				}
			}
		}
	}

	context("Get event by id") {
		test("Should get the event by id") {
			onPremiseTestApp {
				it.get("/api/events/${EventStore.event2Asso1User1.id}") {
					auth(UserStore.user1)
				}.apply {
					status shouldBe HttpStatusCode.OK

					body<TEvent>().name shouldBe EventStore.event2Asso1User1.value
				}
			}
		}

		test("Should get the event by id with pending status because the user is the owner") {
			onPremiseTestApp {
				it.get("/api/events/${EventStore.event1Asso1User1.id}") {
					auth(UserStore.user1)
				}.apply {
					status shouldBe HttpStatusCode.OK

					body<TEvent>().name shouldBe EventStore.event1Asso1User1.value
				}
			}
		}

		test("Should not get the event by id because the user is not the owner and the status is PENDING") {
			onPremiseTestApp {
				it.get("/api/events/${EventStore.event1Asso1User1.id}") {
					auth(UserStore.user2)
				}.apply {
					status shouldBe HttpStatusCode.NotFound

					bodyAsText() shouldBe "L'évènement n'a pas été trouvé"
				}
			}
		}

		test("Should not get the event by id because im not in the association") {
			onPremiseTestApp {
				it.get("/api/events/${EventStore.event2Asso1User1.id}") {
					auth(UserStore.user4)
				}.apply {
					status shouldBe HttpStatusCode.NotFound

					bodyAsText() shouldBe "L'évènement n'a pas été trouvé"
				}
			}
		}
	}

	context("Create event") {
		listOf(
			TCreateEvent(
				name = "New Event",
				description = "New Event Description",
				startDate = workingCreateDate,
				endDate = workingEndDate
			),
			TCreateEvent(
				name = "New Event",
				description = null,
				startDate = workingCreateDate,
				endDate = workingEndDate
			),
			TCreateEvent(
				name = "New Event",
				description = "New Event Description",
				startDate = workingCreateDate,
				endDate = null
			)
		).forEach { newEvent ->
			test("Should create an event") {
				onPremiseTestApp {
					it.post("/api/events") {
						auth(UserStore.user1)
						contentType(ContentType.Application.Json)
						setBody(newEvent)
					}.apply {
						status shouldBe HttpStatusCode.Created

						body<TEvent>().status shouldBe EEventStatus.Pending
					}
				}
			}
		}

		test("Should not create an event because the start date is in the past") {
			onPremiseTestApp {
				it.post("/api/events") {
					auth(UserStore.user1)
					contentType(ContentType.Application.Json)
					setBody(
						TCreateEvent(
							name = "New Event",
							description = "New Event Description",
							startDate = Clock.System.now().minus(
								DateTimePeriod(days = 1),
								TimeZone.currentSystemDefault()
							),
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
					auth(UserStore.user1)
					contentType(ContentType.Application.Json)
					setBody(
						TCreateEvent(
							name = "New Event",
							description = "New Event Description",
							startDate = workingCreateDate,
							endDate = workingCreateDate.minus(
								DateTimePeriod(days = 1),
								TimeZone.currentSystemDefault()
							)
						)
					)
				}.apply {
					status shouldBe HttpStatusCode.BadRequest

					bodyAsText() shouldBe "La date de fin doit être après la date de début"
				}
			}
		}

		test("Should not create an event because name is too long") {
			onPremiseTestApp {
				it.post("/api/events") {
					auth(UserStore.user1)
					contentType(ContentType.Application.Json)
					setBody(
						TCreateEvent(
							name = "a".repeat(101),
							description = "New Event Description",
							startDate = workingCreateDate,
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
					auth(UserStore.user1)
					contentType(ContentType.Application.Json)
					setBody(
						TCreateEvent(
							name = "",
							description = "New Event Description",
							startDate = workingCreateDate,
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
					auth(UserStore.user1)
					contentType(ContentType.Application.Json)
					setBody(
						TCreateEvent(
							name = "New Event",
							description = "a".repeat(1001),
							startDate = workingCreateDate,
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
					auth(UserStore.user1)
					contentType(ContentType.Application.Json)
					setBody(
						TCreateEvent(
							name = "New Event",
							description = "",
							startDate = workingCreateDate,
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
				startDate = workingCreateDate,
				endDate = workingEndDate
			),
			TUpdateEvent(
				name = "Updated Event",
				description = null,
				startDate = workingCreateDate,
				endDate = workingEndDate
			),
			TUpdateEvent(
				name = "Updated Event",
				description = "New Event Description",
				startDate = workingCreateDate,
				endDate = null
			)
		).forEach { newEvent ->
			test("Should update an event") {
				onPremiseTestApp {
					it.put("/api/events/${EventStore.event1Asso1User1.id}") {
						auth(UserStore.user1)
						contentType(ContentType.Application.Json)
						setBody(newEvent)
					}.apply {
						status shouldBe HttpStatusCode.OK

						body<TEvent>().name shouldBe "Updated Event"
					}
				}
			}
		}

		test("Should update an event because the start date is in the past") {
			onPremiseTestApp {
				it.put("/api/events/${EventStore.event1Asso1User1.id}") {
					auth(UserStore.user1)
					contentType(ContentType.Application.Json)
					setBody(
						TUpdateEvent(
							name = "New Event",
							description = "New Event Description",
							startDate = Clock.System.now().minus(
								DateTimePeriod(days = 1),
								TimeZone.currentSystemDefault()
							),
							endDate = null
						)
					)
				}.apply {
					status shouldBe HttpStatusCode.OK
				}
			}
		}

		test("Should not update an event because the start date is after the end date") {
			onPremiseTestApp {
				it.put("/api/events/${EventStore.event1Asso1User1.id}") {
					auth(UserStore.user1)
					contentType(ContentType.Application.Json)
					setBody(
						TUpdateEvent(
							name = "New Event",
							description = "New Event Description",
							startDate = workingCreateDate,
							endDate = workingCreateDate.minus(
								DateTimePeriod(days = 1),
								TimeZone.currentSystemDefault()
							)
						)
					)
				}.apply {
					status shouldBe HttpStatusCode.BadRequest

					bodyAsText() shouldBe "La date de fin doit être après la date de début"
				}
			}
		}

		test("Should not update an event because name is too long") {
			onPremiseTestApp {
				it.put("/api/events/${EventStore.event1Asso1User1.id}") {
					auth(UserStore.user1)
					contentType(ContentType.Application.Json)
					setBody(
						TUpdateEvent(
							name = "a".repeat(101),
							description = "New Event Description",
							startDate = workingCreateDate,
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
				it.put("/api/events/${EventStore.event1Asso1User1.id}") {
					auth(UserStore.user1)
					contentType(ContentType.Application.Json)
					setBody(
						TUpdateEvent(
							name = "",
							description = "New Event Description",
							startDate = workingCreateDate,
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
				it.put("/api/events/${EventStore.event1Asso1User1.id}") {
					auth(UserStore.user1)
					contentType(ContentType.Application.Json)
					setBody(
						TUpdateEvent(
							name = "New Event",
							description = "a".repeat(1001),
							startDate = workingCreateDate,
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
				it.put("/api/events/${EventStore.event1Asso1User1.id}") {
					auth(UserStore.user1)
					contentType(ContentType.Application.Json)
					setBody(
						TUpdateEvent(
							name = "New Event",
							description = "",
							startDate = workingCreateDate,
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
				it.put("/api/events/${EventStore.event2Asso1User1.id}") {
					auth(UserStore.user2)
					contentType(ContentType.Application.Json)
					setBody(
						TUpdateEvent(
							name = "New Event",
							description = "New Event Description",
							startDate = workingCreateDate,
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
				it.put("/api/events/${EventStore.event6Asso1User2.id}") {
					auth(UserStore.user1)
					contentType(ContentType.Application.Json)
					setBody(
						TUpdateEvent(
							name = "New Event",
							description = "New Event Description",
							startDate = workingCreateDate,
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
				it.put("/api/events/${EventStore.unknown.id}") {
					auth(UserStore.user1)
					contentType(ContentType.Application.Json)
					setBody(
						TUpdateEvent(
							name = "New Event",
							description = "New Event Description",
							startDate = workingCreateDate,
							endDate = null
						)
					)
				}.apply {
					status shouldBe HttpStatusCode.NotFound

					bodyAsText() shouldBe "Event ${EventStore.unknown.id} introuvable"
				}
			}
		}
	}

	context("Schedule event") {
		test("Should schedule pending event") {
			onPremiseTestApp {
				it.patch("/api/events/${EventStore.event1Asso1User1.id}/schedule") {
					auth(UserStore.user1)
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.OK
				}
			}
		}

		test("Should not schedule the already scheduled event") {
			onPremiseTestApp {
				it.patch("/api/events/${EventStore.event2Asso1User1.id}/schedule") {
					auth(UserStore.user1)
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.Forbidden

					bodyAsText() shouldBe "Event déjà scheduled"
				}
			}
		}

		test("Should not schedule event because it does not exist") {
			onPremiseTestApp {
				it.patch("/api/events/${EventStore.unknown.id}/schedule") {
					auth(UserStore.user1)
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.NotFound

					bodyAsText() shouldBe "Event ${EventStore.unknown.id} introuvable"
				}
			}
		}

		test("Should not schedule event if the user is not participating") {
			onPremiseTestApp {
				it.patch("/api/events/${EventStore.event6Asso1User2.id}/schedule") {
					auth(UserStore.user1)
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.Forbidden

					bodyAsText() shouldBe "Vous ne participez pas à cet événement"
				}
			}
		}

		test("Should not update an event if the user is not an organizer") {
			onPremiseTestApp {
				it.patch("/api/events/${EventStore.event2Asso1User1.id}/schedule") {
					auth(UserStore.user2)
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
				it.patch("/api/events/${EventStore.event2Asso1User1.id}/cancel") {
					auth(UserStore.user1)
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.OK
				}
			}
		}

		test("Should not cancel the pending event") {
			onPremiseTestApp {
				it.patch("/api/events/${EventStore.event1Asso1User1.id}/cancel") {
					auth(UserStore.user1)
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.Forbidden

					bodyAsText() shouldBe "Seul un événement planifié peut être annulé"
				}
			}
		}

		test("Should not cancel the already canceled event") {
			onPremiseTestApp {
				it.patch("/api/events/${EventStore.event3Asso1User1.id}/cancel") {
					auth(UserStore.user1)
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.Forbidden

					bodyAsText() shouldBe "Event déjà cancelled"
				}
			}
		}

		test("Should not cancel the terminated event") {
			onPremiseTestApp {
				it.patch("/api/events/${EventStore.event4Asso1User1.id}/cancel") {
					auth(UserStore.user1)
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.Forbidden

					bodyAsText() shouldBe "Seul un événement planifié peut être annulé"
				}
			}
		}

		test("Should not cancel event because it does not exist") {
			onPremiseTestApp {
				it.patch("/api/events/${EventStore.unknown.id}/cancel") {
					auth(UserStore.user1)
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.NotFound

					bodyAsText() shouldBe "Event ${EventStore.unknown.id} introuvable"
				}
			}
		}

		test("Should not cancel event if the user is not participating") {
			onPremiseTestApp {
				it.patch("/api/events/${EventStore.event6Asso1User2.id}/cancel") {
					auth(UserStore.user1)
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.Forbidden

					bodyAsText() shouldBe "Vous ne participez pas à cet événement"
				}
			}
		}

		test("Should not cancel event if the user is not an organizer") {
			onPremiseTestApp {
				it.patch("/api/events/${EventStore.event2Asso1User1.id}/cancel") {
					auth(UserStore.user2)
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
				it.patch("/api/events/${EventStore.event2Asso1User1.id}/pend") {
					auth(UserStore.user1)
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.OK
				}
			}
		}

		test("Should not pend the already pending event") {
			onPremiseTestApp {
				it.patch("/api/events/${EventStore.event1Asso1User1.id}/pend") {
					auth(UserStore.user1)
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.Forbidden

					bodyAsText() shouldBe "Event déjà pending"
				}
			}
		}

		test("Should not pend event because it does not exist") {
			onPremiseTestApp {
				it.patch("/api/events/${EventStore.unknown.id}/pend") {
					auth(UserStore.user1)
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.NotFound

					bodyAsText() shouldBe "Event ${EventStore.unknown.id} introuvable"
				}
			}
		}

		test("Should not pend event if the user is not participating") {
			onPremiseTestApp {
				it.patch("/api/events/${EventStore.event6Asso1User2.id}/pend") {
					auth(UserStore.user1)
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.Forbidden

					bodyAsText() shouldBe "Vous ne participez pas à cet événement"
				}
			}
		}

		test("Should not pend event if the user is not an organizer") {
			onPremiseTestApp {
				it.patch("/api/events/${EventStore.event2Asso1User1.id}/pend") {
					auth(UserStore.user2)
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.Forbidden

					bodyAsText() shouldBe "Seul l'organisateur peut modifier le statut de l'événement"
				}
			}
		}

		test("Should not pend event if the user is not an organizer") {
			onPremiseTestApp {
				it.patch("/api/events/${EventStore.event2Asso1User1.id}/pend") {
					auth(UserStore.user2)
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.Forbidden

					bodyAsText() shouldBe "Seul l'organisateur peut modifier le statut de l'événement"
				}
			}
		}

		test("Should not pend event if the user is not the owner") {
			onPremiseTestApp {
				it.patch("/api/events/${EventStore.event1Asso2User3.id}/pend") {
					auth(UserStore.user4)
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
				it.patch("/api/events/${EventStore.event2Asso1User1.id}/finish") {
					auth(UserStore.user1)
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.OK
				}
			}
		}

		test("Should not finish the already finished event") {
			onPremiseTestApp {
				it.patch("/api/events/${EventStore.event4Asso1User1.id}/finish") {
					auth(UserStore.user1)
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.Forbidden

					bodyAsText() shouldBe "Event déjà finished"
				}
			}
		}

		test("Should not finish the pending event") {
			onPremiseTestApp {
				it.patch("/api/events/${EventStore.event1Asso1User1.id}/finish") {
					auth(UserStore.user1)
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.Forbidden

					bodyAsText() shouldBe "Seul un événement planifié peut être terminé"
				}
			}
		}

		test("Should not finish the canceled event") {
			onPremiseTestApp {
				it.patch("/api/events/${EventStore.event3Asso1User1.id}/finish") {
					auth(UserStore.user1)
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.Forbidden

					bodyAsText() shouldBe "Seul un événement planifié peut être terminé"
				}
			}
		}

		test("Should not finish event because it does not exist") {
			onPremiseTestApp {
				it.patch("/api/events/${EventStore.unknown.id}/finish") {
					auth(UserStore.user1)
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.NotFound

					bodyAsText() shouldBe "Event ${EventStore.unknown.id} introuvable"
				}
			}
		}

		test("Should not finish event if the user is not participating") {
			onPremiseTestApp {
				it.patch("/api/events/${EventStore.event6Asso1User2.id}/finish") {
					auth(UserStore.user1)
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.Forbidden

					bodyAsText() shouldBe "Vous ne participez pas à cet événement"
				}
			}
		}

		test("Should not finish event if the user is not an organizer") {
			onPremiseTestApp {
				it.patch("/api/events/${EventStore.event2Asso1User1.id}/finish") {
					auth(UserStore.user2)
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.Forbidden

					bodyAsText() shouldBe "Seul l'organisateur peut modifier le statut de l'événement"
				}
			}
		}

		test("Should not finish event if the user is not an organizer") {
			onPremiseTestApp {
				it.patch("/api/events/${EventStore.event2Asso1User1.id}/finish") {
					auth(UserStore.user2)
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
							javaClass.classLoader.getResource("profile.jpg")?.file
								?: error("File profile.jpg not found")
						)

						it.patch("/api/events/${EventStore.event1Asso1User1.id}/image") {
							val boundary = "WebAppBoundary"
							auth(UserStore.user1)
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

					it.patch("/api/events/${EventStore.event1Asso1User1.id}/image") {
						val boundary = "WebAppBoundary"
						auth(UserStore.user1)
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

				it.patch("/api/events/${EventStore.event1Asso1User1.id}/image") {
					val boundary = "WebAppBoundary"
					auth(UserStore.user1)
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

				it.patch("/api/events/${EventStore.event2Asso1User1.id}/image") {
					val boundary = "WebAppBoundary"
					auth(UserStore.user2)
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

				it.patch("/api/events/${EventStore.event6Asso1User2.id}/image") {
					val boundary = "WebAppBoundary"
					auth(UserStore.user1)
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

				it.patch("/api/events/${EventStore.unknown.id}/image") {
					val boundary = "WebAppBoundary"
					auth(UserStore.user1)
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

					bodyAsText() shouldBe "Event ${EventStore.unknown.id} introuvable"
				}
			}
		}
	}

	context("Delete event") {
		test("Should delete the event") {
			onPremiseTestApp {
				it.delete("/api/events/${EventStore.event1Asso1User1.id}") {
					auth(UserStore.user1)
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.OK
				}
			}
		}

		test("Should not delete the event because im not the owner") {
			onPremiseTestApp {
				it.delete("/api/events/${EventStore.event6Asso1User2.id}") {
					auth(UserStore.user1)
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.Forbidden

					bodyAsText() shouldBe "Seul le propriétaire peut supprimer l'événement"
				}
			}
		}

		test("Should not delete the event because it does not exist") {
			onPremiseTestApp {
				it.delete("/api/events/${EventStore.unknown.id}") {
					auth(UserStore.user1)
					contentType(ContentType.Application.Json)
				}.apply {
					status shouldBe HttpStatusCode.NotFound

					bodyAsText() shouldBe "Event ${EventStore.unknown.id} introuvable"
				}
			}
		}
	}
})
