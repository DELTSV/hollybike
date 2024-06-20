package hollybike.api.routing.controller

import hollybike.api.exceptions.AssociationNotFound
import hollybike.api.exceptions.NotAllowedException
import hollybike.api.plugins.user
import hollybike.api.repository.associationMapper
import hollybike.api.repository.journeysMapper
import hollybike.api.repository.userMapper
import hollybike.api.routing.resources.Journeys
import hollybike.api.services.PositionService
import hollybike.api.services.journey.JourneyService
import hollybike.api.types.journey.toGeoJson
import hollybike.api.types.journey.*
import hollybike.api.types.lists.TLists
import hollybike.api.types.position.EPositionScope
import hollybike.api.types.position.TPositionRequest
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
import kotlinx.coroutines.delay
import kotlinx.datetime.Clock
import kotlinx.serialization.decodeFromString
import kotlinx.serialization.json.Json
import nl.adaptivity.xmlutil.*
import nl.adaptivity.xmlutil.serialization.UnknownChildHandler
import nl.adaptivity.xmlutil.serialization.XML
import java.util.Timer
import kotlin.concurrent.schedule
import kotlin.math.ceil
import kotlin.time.Duration.Companion.hours

class JourneyController(
	application: Application,
	private val journeyService: JourneyService,
	private val positionService: PositionService
) {
	private val journeyPositions = mutableMapOf<Int, TJourneyPositions>()

	private val timer = Timer()

	init {
		positionService.subscribe("journey-start-position") { response ->
			journeyPositions[response.identifier]?.let { journeyPosition ->
				journeyService.setJourneyStartPosition(journeyPosition.journey, response.content)
				journeyPosition.start = response
			}
		}
		positionService.subscribe("journey-end-position") { response ->
			journeyPositions[response.identifier]?.let { journeyPosition ->
				journeyService.setJourneyEndPosition(journeyPosition.journey, response.content)
				journeyPosition.end = response
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

	private val json = Json {
		ignoreUnknownKeys = true
	}

	private fun Route.getAll() {
		get<Journeys> {
			val param = call.request.queryParameters.getSearchParam(journeysMapper + userMapper + associationMapper)
			val list = journeyService.getAll(call.user, param).map { TJourney(it) }
			val count = journeyService.getAllCount(call.user, param)
			call.respond(
				TLists(
					list,
					param.page,
					ceil(count.toDouble() / param.perPage).toInt(),
					param.perPage,
					count.toInt()
				)
			)
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

			val cleanedGeoJson = geoJson.clean()

			cleanedGeoJson.apply {
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
				cleanedGeoJson,
				contentType.toString()
			).onSuccess {
				println("File uploaded")
				cleanedGeoJson.start?.let { start ->
					println("get start position")
					cleanedGeoJson.end?.let { end ->
						println("get end positions")
						journeyPositions[journey.id.value] = TJourneyPositions(
							journey,
							true
						)
						println("send end position request")
						positionService.getPositionOrPush(
							"journey-end-position",
							journey.id.value,
							TPositionRequest(end[1], end[0], end.getOrNull(2), EPositionScope.Country)
						)
						println("request sent")
					} ?: run {
						journeyPositions[journey.id.value] = TJourneyPositions(
							journey,
							false
						)
					}
					println("send start position request")
					positionService.getPositionOrPush(
						"journey-start-position",
						journey.id.value,
						TPositionRequest(start[1], start[0], start.getOrNull(2), EPositionScope.Country)
					)
					println("request sent")
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
		get<Journeys.Id.Positions> {
			val journey = journeyService.getById(call.user, it.id.id) ?: run {
				return@get call.respond(HttpStatusCode.NotFound, "Trajet inconnu")
			}
			journeyPositions[journey.id.value]?.let { journeyPosition ->
				repeat(60) {
					if (journeyPosition.haveEnd) {
						if (journeyPosition.start != null && journeyPosition.end != null) {
							journeyPositions.remove(journey.id.value)
							return@get call.respond(TJourney(journey))
						}
					} else {
						if (journeyPosition.start != null) {
							journeyPositions.remove(journey.id.value)
							return@get call.respond(TJourney(journey))
						}
					}
					delay(5_000)
				}
				call.respond(HttpStatusCode.TooEarly, "Les positions n'ont pas encore été récupérées")
			} ?: run {
				return@get call.respond(HttpStatusCode.Gone, "Les positions ont déjà été récupérées")
			}
		}
	}
}