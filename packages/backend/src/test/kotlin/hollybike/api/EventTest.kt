package hollybike.api

import hollybike.api.base.IntegrationSpec
import hollybike.api.types.association.TAssociation
import hollybike.api.types.event.EEventStatus
import hollybike.api.types.event.TCreateEvent
import hollybike.api.types.event.TEvent
import hollybike.api.types.event.TEventPartial
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
		val createDate = Clock.System.now().plus(
			DateTimePeriod(months = 1),
			TimeZone.currentSystemDefault()
		)

		val endDate = createDate.plus(
			DateTimePeriod(days = 1),
			TimeZone.currentSystemDefault()
		)

		listOf(
			TCreateEvent(
				name = "New Event",
				description = "New Association Description",
				startDate = createDate.toString(),
				endDate = endDate.toString()
			),
			TCreateEvent(
				name = "New Event",
				description = null,
				startDate = createDate.toString(),
				endDate = endDate.toString()
			),
			TCreateEvent(
				name = "New Event",
				description = "New Association Description",
				startDate = createDate.toString(),
				endDate = null
			)
		).forEach { newEvent ->
			test("Should create an event") {
				onPremiseTestApp {
					it.post("/api/events") {
						header("Authorization", "Bearer ${tokenStore.get("user1@hollybike.fr")}")
						contentType(ContentType.Application.Json)
						setBody(newEvent)
					}.apply {
						status shouldBe HttpStatusCode.Created

						body<TEvent>().status shouldBe EEventStatus.PENDING
					}
				}
			}
		}
	}
})