package hollybike.api.routing.controller

import hollybike.api.exceptions.AssociationNotFound
import hollybike.api.exceptions.NotAllowedException
import hollybike.api.plugins.user
import hollybike.api.repository.associationMapper
import hollybike.api.repository.journeysMapper
import hollybike.api.repository.userMapper
import hollybike.api.routing.resources.Journeys
import hollybike.api.services.JourneyService
import hollybike.api.types.journey.TJourney
import hollybike.api.types.journey.TNewJourney
import hollybike.api.types.lists.TLists
import hollybike.api.utils.GeoJson
import hollybike.api.utils.checkContentType
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
import kotlin.math.ceil

class JourneyController(
	application: Application,
	private val journeyService: JourneyService
) {
	init {
		application.routing {
			authenticate {
				getAll()
				metaData()
				createJourney()
				getJourney()
				addFile()
			}
		}
	}

	private fun Route.getAll() {
		get<Journeys> {
			val param = call.request.queryParameters.getSearchParam(journeysMapper + userMapper + associationMapper)
			val list = journeyService.getAll(call.user, param).map { TJourney(it) }
			val count = journeyService.getAllCount(call.user, param)
			call.respond(TLists(
				list,
				param.page,
				ceil(count.toDouble() / param.perPage).toInt(),
				param.perPage,
				count.toInt()
			))
		}
	}

	private fun Route.createJourney() {
		post<Journeys> {
			val newJourney = call.receive<TNewJourney>()
			journeyService.createJourney(call.user, newJourney).onSuccess {
				call.respond(HttpStatusCode.Created, TJourney(it))
			}.onFailure {
				when(it) {
					is NotAllowedException -> call.respond(HttpStatusCode.Forbidden)
					is AssociationNotFound -> call.respond(HttpStatusCode.NotFound, "Association inconnue")
					else -> call.respond(HttpStatusCode.InternalServerError)
				}
			}
		}
	}

	private fun Route.metaData() {
		get<Journeys.MetaData> {
			call.respond(journeysMapper + userMapper + associationMapper)
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

			val contentType = ContentType.Application.GeoJson

			val journey = journeyService.getById(call.user, it.id.id) ?: run {
				call.respond(HttpStatusCode.NotFound, "Le trajet n'as pas été trouvé")
				return@post
			}

			journeyService.uploadFile(
				call.user,
				journey,
				file.streamProvider().readBytes(),
				contentType.toString()
			).onSuccess {
				call.respond(HttpStatusCode.OK, TJourney(journey))
			}.onFailure { err ->
				when(err) {
					is NotAllowedException -> call.respond(HttpStatusCode.Forbidden)
					else -> call.respond(HttpStatusCode.InternalServerError)
				}
			}
		}
	}
}