/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.routing.controller

import hollybike.api.json
import hollybike.api.plugins.user
import hollybike.api.repository.userJourneyMapper
import hollybike.api.routing.resources.UserJourneys
import hollybike.api.services.UserEventPositionService
import hollybike.api.services.storage.StorageService
import hollybike.api.types.event.participation.TUserJourney
import hollybike.api.types.journey.GeoJson
import hollybike.api.types.journey.toGpx
import hollybike.api.types.lists.TLists
import hollybike.api.utils.search.getSearchParam
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.request.*
import io.ktor.server.resources.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import kotlinx.serialization.encodeToString
import nl.adaptivity.xmlutil.ExperimentalXmlUtilApi
import nl.adaptivity.xmlutil.serialization.UnknownChildHandler
import nl.adaptivity.xmlutil.serialization.XML

class UserJourneyController(
	application: Application,
	private val userEventPositionService: UserEventPositionService,
	private val storageService: StorageService
) {
	init {
		application.routing {
			authenticate {
				getUserUserJourneys()
				getUserJourney()
				deleteUserJourney()
				getUserJourneyFile()
			}
		}
	}

	@OptIn(ExperimentalXmlUtilApi::class)
	private val xml = XML {
		defaultPolicy {
			unknownChildHandler =
				UnknownChildHandler { _, _, _, _, _ ->
					emptyList()
				}
		}
	}

	private fun Route.getUserUserJourneys() {
		get<UserJourneys.User> { data ->
			val searchParam = call.request.queryParameters.getSearchParam(userJourneyMapper)

			val userJourneys = userEventPositionService.getUserJourneys(call.user, data.id, searchParam)
			val totalUserJourneys = userEventPositionService.countUserJourneys(data.id, searchParam)

			call.respond(
				TLists(
					userJourneys.map {
						TUserJourney(
							it,
							userEventPositionService.getIsBetterThanForUserJourney(it)
						)
					}, searchParam, totalUserJourneys
				)
			)
		}
	}

	private fun Route.getUserJourney() {
		get<UserJourneys.Id> {
			val userJourney = userEventPositionService.getUserJourney(call.user, it.id) ?: run {
				return@get call.respond(HttpStatusCode.NotFound, "Trajet inconnu")
			}

			call.respond(HttpStatusCode.OK, TUserJourney(userJourney, userEventPositionService.getIsBetterThanForUserJourney(userJourney)))
		}
	}

	private fun Route.deleteUserJourney() {
		delete<UserJourneys.Id> {
			val userJourney = userEventPositionService.getUserJourney(call.user, it.id) ?: run {
				return@delete call.respond(HttpStatusCode.NotFound, "Trajet inconnu")
			}

			userEventPositionService.deleteUserJourney(userJourney)

			call.respond(HttpStatusCode.NoContent)
		}
	}

	private fun Route.getUserJourneyFile() {
		get<UserJourneys.Id.File> {
			val userJourney = userEventPositionService.getUserJourney(call.user, it.file.id) ?: run {
				return@get call.respond(HttpStatusCode.NotFound, "Trajet inconnu")
			}

			val data = storageService.retrieve(userJourney.journey) ?: run {
				return@get call.respond(HttpStatusCode.NotFound, "Le fichier n'existe pas")
			}

			val geojson = json.decodeFromString<GeoJson>(data.toString(Charsets.UTF_8))

			if (call.request.accept()?.contains("geo+json") == true) {
				call.respond(json.encodeToString(geojson))
			} else if (call.request.accept()?.contains("gpx") == true) {
				call.respond(xml.encodeToString(geojson.toGpx()))
			} else {
				call.respond(HttpStatusCode.BadRequest, "Il manque un format de retour")
			}
		}
	}
}