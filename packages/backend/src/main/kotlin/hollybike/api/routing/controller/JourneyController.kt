package hollybike.api.routing.controller

import hollybike.api.exceptions.AssociationNotFound
import hollybike.api.exceptions.NotAllowedException
import hollybike.api.json
import hollybike.api.plugins.user
import hollybike.api.repository.associationMapper
import hollybike.api.repository.journeysMapper
import hollybike.api.repository.userMapper
import hollybike.api.routing.resources.Journeys
import hollybike.api.services.PositionService
import hollybike.api.services.journey.JourneyService
import hollybike.api.services.storage.StorageService
import hollybike.api.types.association.TPartialAssociation
import hollybike.api.types.journey.*
import hollybike.api.types.lists.TLists
import hollybike.api.types.position.EPositionScope
import hollybike.api.types.position.TPosition
import hollybike.api.types.position.TPositionRequest
import hollybike.api.types.position.TPositionResult
import hollybike.api.types.user.TUserPartial
import hollybike.api.utils.GeoJson
import hollybike.api.utils.search.getMapperData
import hollybike.api.utils.search.getSearchParam
import io.ktor.http.*
import io.ktor.http.content.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.request.*
import io.ktor.server.resources.*
import io.ktor.server.resources.post
import io.ktor.server.response.*
import io.ktor.server.routing.*
import kotlinx.coroutines.async
import kotlinx.coroutines.awaitAll
import kotlinx.datetime.Clock
import kotlinx.serialization.decodeFromString
import kotlinx.serialization.encodeToString
import nl.adaptivity.xmlutil.ExperimentalXmlUtilApi
import nl.adaptivity.xmlutil.serialization.UnknownChildHandler
import nl.adaptivity.xmlutil.serialization.XML
import java.util.*
import kotlin.concurrent.schedule
import kotlin.time.Duration.Companion.hours

class JourneyController(
	application: Application,
	private val journeyService: JourneyService,
	private val positionService: PositionService,
	private val storageService: StorageService
) {
	private val journeyPositions = mutableMapOf<Int, TJourneyPositions>()

	private val timer = Timer()

	init {
		positionService.subscribe("journey-start-position") { response ->
			if (response is TPositionResult.Success) {
				journeyPositions[response.identifier]?.let { journeyPosition ->
					journeyService.setJourneyStartPosition(journeyPosition.journey, response.position)
					journeyPosition.start = response.position
				}
			} else if (response is TPositionResult.Error) {
				journeyPositions.remove(response.identifier)
				println("Error while getting start position for journey ${response.identifier}: ${response.message}")
			}
		}

		positionService.subscribe("journey-end-position") { response ->
			if (response is TPositionResult.Success) {
				journeyPositions[response.identifier]?.let { journeyPosition ->
					journeyService.setJourneyEndPosition(journeyPosition.journey, response.position)
					journeyPosition.end = response.position
				}
			} else if (response is TPositionResult.Error) {
				journeyPositions.remove(response.identifier)
				println("Error while getting end position for journey ${response.identifier}: ${response.message}")
			}
		}

		positionService.subscribe("journey-destination-position") { response ->
			if (response is TPositionResult.Success) {
				journeyPositions[response.identifier]?.let { journeyPosition ->
					journeyService.setJourneyDestinationPosition(journeyPosition.journey, response.position)
					journeyPosition.destination = response.position
				}
			} else if (response is TPositionResult.Error) {
				journeyPositions.remove(response.identifier)
				println("Error while getting destination position for journey ${response.identifier}: ${response.message}")
			}
		}

		timer.schedule(0L, 3600_000L) {
			journeyPositions.filterValues { (it.askedAt + 1.hours) < Clock.System.now() }.map { it.key }.forEach {
				journeyPositions.remove(it)
			}
		}

		application.routing {
			authenticate {
				getAll()
				metaData()
				createJourney()
				getJourney()
				addFile()
				deleteJourney()
				getJourneyPositions()
				getJourneyFile()
			}
		}
	}

	@OptIn(ExperimentalXmlUtilApi::class)
	private val xml = XML {
		defaultPolicy {
			unknownChildHandler =
				UnknownChildHandler { _, _, _, name, _ ->
					emptyList()
				}
		}
	}

	private fun Route.getAll() {
		get<Journeys> {
			val param = call.request.queryParameters.getSearchParam(journeysMapper + userMapper + associationMapper)
			val list = journeyService.getAll(call.user, param).map { TJourney(it) }
			val count = journeyService.getAllCount(call.user, param)
			call.respond(TLists(list, param, count))
		}
	}

	private fun Route.createJourney() {
		post<Journeys> {
			val newJourney = call.receive<TNewJourney>()
			journeyService.createJourney(call.user, newJourney).onSuccess {
				call.respond(HttpStatusCode.Created, TJourney(it))
			}.onFailure {
				when (it) {
					is NotAllowedException -> call.respond(HttpStatusCode.Forbidden)
					is AssociationNotFound -> call.respond(HttpStatusCode.NotFound, "Association inconnue")
					else -> call.respond(HttpStatusCode.InternalServerError)
				}
			}
		}
	}

	private fun Route.metaData() {
		get<Journeys.MetaData> {
			call.respond((journeysMapper + userMapper + associationMapper).getMapperData())
		}
	}

	private fun Route.getJourney() {
		get<Journeys.Id> {
			journeyService.getById(call.user, it.id)?.let { journey ->
				call.respond(TJourney(journey))
			} ?: run {
				call.respond(HttpStatusCode.NotFound, "Le trajet n'as pas été trouvé")
			}
		}
	}

	private fun Route.addFile() {
		post<Journeys.Id.File> {
			val multipart = call.receiveMultipart()

			val file = multipart.readPart() as PartData.FileItem

			val text = file.streamProvider().readBytes().toString(Charsets.UTF_8)

			val geoJson = try {
				xml.decodeFromString<Gpx>(text).toGeoJson()
			} catch (_: Exception) {
				try {
					json.decodeFromString<GeoJson>(text)
				} catch (_: Exception) {
					null
				}
			} ?: run {
				return@post call.respond(HttpStatusCode.BadRequest, "Le fichier n'est n'y un GPX ni un GeoJSON")
			}

			geoJson.apply {
				bbox = getBoundingBox()
			}

			val contentType = ContentType.Application.GeoJson

			val journey = journeyService.getById(call.user, it.id.id) ?: run {
				call.respond(HttpStatusCode.NotFound, "Le trajet n'as pas été trouvé")
				return@post
			}

			journeyService.uploadFile(
				call.user,
				journey,
				geoJson,
				contentType.toString()
			).onSuccess {
				println("File uploaded")

				geoJson.start?.let { start ->
					val end = geoJson.end
					val destination = geoJson.farthestPointFromStart

					journeyPositions[journey.id.value] = TJourneyPositions(
						journey,
						haveEnd = end != null,
						haveDestination = destination != null
					)

					if (end != null) {
						positionService.getPositionOrPush(
							"journey-end-position",
							journey.id.value,
							TPositionRequest(end[1], end[0], end.getOrNull(2), EPositionScope.Country)
						)
					}

					if (destination != null) {
						positionService.getPositionOrPush(
							"journey-destination-position",
							journey.id.value,
							TPositionRequest(
								destination[1],
								destination[0],
								destination.getOrNull(2),
								EPositionScope.Country
							)
						)
					}

					positionService.getPositionOrPush(
						"journey-start-position",
						journey.id.value,
						TPositionRequest(start[1], start[0], start.getOrNull(2), EPositionScope.Country)
					)
				}

				call.respond(HttpStatusCode.OK, TJourney(journey))
			}.onFailure { err ->
				when (err) {
					is NotAllowedException -> call.respond(HttpStatusCode.Forbidden)
					else -> call.respond(HttpStatusCode.InternalServerError)
				}
			}
		}
	}

	private fun Route.deleteJourney() {
		delete<Journeys.Id> {
			val journey = journeyService.getById(call.user, it.id) ?: run {
				return@delete call.respond(HttpStatusCode.NotFound, "Trajet inconnu")
			}
			if (journeyService.deleteJourney(call.user, journey)) {
				call.respond(HttpStatusCode.NoContent)
			} else {
				call.respond(HttpStatusCode.Forbidden)
			}
		}
	}

	private fun Route.getJourneyPositions() {
		get<Journeys.Id.Positions> { data ->
			val journey = journeyService.getById(call.user, data.id.id) ?: run {
				return@get call.respond(HttpStatusCode.NotFound, "Trajet inconnu")
			}

			journeyPositions[journey.id.value]?.let { journeyPosition ->
				val hasStart = journeyPosition.start != null
				val hasEnd = journeyPosition.end != null || !journeyPosition.haveEnd
				val hasDestination = journeyPosition.destination != null || !journeyPosition.haveDestination

				if (hasStart && hasEnd && hasDestination) {
					journeyPositions.remove(journey.id.value)
					return@get call.respond(TJourney(journey))
				}

				val waiters = mutableListOf<String>()

				if (!hasStart) {
					waiters.add("journey-start-position")
				}

				if (!hasEnd) {
					waiters.add("journey-end-position")
				}

				if (!hasDestination) {
					waiters.add("journey-destination-position")
				}

				val requests = waiters.map {
					async {
						positionService.awaitResult(it, journey.id.value, 360)
					}
				}

				val postions = awaitAll(*requests.toTypedArray())

				postions.forEach {
					if (it is TPositionResult.Success) {
						when (it.topic) {
							"journey-start-position" -> {
								journeyPosition.start = it.position
							}

							"journey-end-position" -> {
								journeyPosition.end = it.position
							}

							"journey-destination-position" -> {
								journeyPosition.destination = it.position
							}
						}
					}
				}

				if (postions.any { it is TPositionResult.Error }) {
					return@get call.respond(
						HttpStatusCode.InternalServerError,
						"Erreur lors de la récupération des positions"
					)
				}

				if (postions.any { it == null }) {
					return@get call.respond(HttpStatusCode.TooEarly, "Les positions n'ont pas encore été récupérées")
				}

				call.respond(
					TJourney(
						journey.id.value,
						journey.name,
						journey.signedFile,
						journey.signedPreviewImage,
						journey.previewImage,
						journey.createdAt,
						TUserPartial(journey.creator),
						TPartialAssociation(journey.association),
						journeyPosition.start?.let { TPosition(it) },
						journeyPosition.end?.let { TPosition(it) },
						journeyPosition.destination?.let { TPosition(it) }
					)
				)
			} ?: run {
				return@get call.respond(HttpStatusCode.Gone, "Les positions ont déjà été récupérées")
			}
		}
	}

	private fun Route.getJourneyFile() {
		get<Journeys.Id.File> {
			val journey = journeyService.getById(call.user, it.id.id) ?: run {
				return@get call.respond(HttpStatusCode.NotFound, "Trajet inconnu")
			}

			val data = journey.file?.let { file ->
				storageService.retrieve(file) ?: run {
					return@get call.respond(HttpStatusCode.NotFound, "Le fichier n'existe pas")
				}
			} ?: run {
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