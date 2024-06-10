package hollybike.api.routing.controller

import hollybike.api.plugins.user
import hollybike.api.repository.User
import hollybike.api.repository.Users
import hollybike.api.repository.eventImagesMapper
import hollybike.api.repository.eventMapper
import hollybike.api.routing.resources.Events
import hollybike.api.services.EventImageService
import hollybike.api.services.storage.StorageService
import hollybike.api.types.event.image.*
import hollybike.api.types.lists.TLists
import hollybike.api.types.user.EUserScope
import hollybike.api.utils.checkContentType
import hollybike.api.utils.get
import hollybike.api.utils.search.*
import io.ktor.http.*
import io.ktor.http.content.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.request.*
import io.ktor.server.resources.*
import io.ktor.server.response.*
import io.ktor.server.routing.Route
import io.ktor.server.routing.routing
import kotlinx.serialization.json.Json
import kotlin.math.ceil

class EventImageController(
	application: Application,
	private val eventImageService: EventImageService,
	private val storageService: StorageService
) {
	private val mapper = eventImagesMapper + eventMapper

	init {
		application.routing {
			authenticate {
				getImages()
				getMyImages()
				uploadImages()
				deleteImage()
				getMetaData()
			}
		}
	}

	private fun getImagesWithPagination(user: User, searchParam: SearchParam): TLists<TEventImage> {
		val images = eventImageService.getImages(user, searchParam)
		val imageCount = eventImageService.countImages(user, searchParam)

		return TLists(
			data = images.map { image -> TEventImage(image, storageService.signer.sign) },
			page = searchParam.page,
			perPage = searchParam.perPage,
			totalPage = ceil(imageCount.toDouble() / searchParam.perPage).toInt(),
			totalData = imageCount,
		)
	}

	private fun Route.getImages() {
		get<Events.Images> {
			val searchParam = call.request.queryParameters.getSearchParam(mapper)

			call.respond(getImagesWithPagination(call.user, searchParam))
		}
	}

	private fun Route.getMyImages() {
		get<Events.Images.Me> {
			val searchParam = call.request.queryParameters.getSearchParam(mapper)

			searchParam.filter.add(Filter(Users.id, call.user.id.toString(), FilterMode.EQUAL))

			call.respond(getImagesWithPagination(call.user, searchParam))
		}
	}

	private fun Route.uploadImages() {
		post<Events.Id.Images> { data ->
			val multipart = call.receiveMultipart()
			val allParts = multipart.readAllParts()

			val images = allParts.filterIsInstance<PartData.FileItem>().map { item ->
				val pattern = Regex("""image-(\d+)""")

				(item.name ?: "<empty>").let {
					if (!pattern.matches(it)) {
						return@post call.respond(
							HttpStatusCode.BadRequest,
							"Invalid file name $it, must be image-<index>"
						)
					}
				}

				val index = pattern.matchEntire(item.name!!)!!.groupValues[1].toInt()

				val metadata = allParts.filterIsInstance<PartData.FormItem>().firstOrNull {
					it.name == "metadata-$index"
				}.let {
					if (it == null) {
						return@post call.respond(HttpStatusCode.BadRequest, "Missing metadata for file ${item.name}")
					}

					Json.decodeFromString<TImageMetadata>(it.value)
				}

				val contentType = checkContentType(item).getOrElse {
					return@post call.respond(HttpStatusCode.BadRequest, it.message!!)
				}

				TImageDataWithMetadata(
					data = item.streamProvider().readBytes(),
					contentType = contentType.toString(),
					metadata = metadata
				)
			}

			eventImageService.uploadImages(call.user, data.event.id, images).onSuccess {
				call.respond(HttpStatusCode.Created, it.map { image -> TEventImage(image, storageService.signer.sign) })
			}.onFailure {
				eventImageService.handleEventExceptions(it, call)
			}
		}
	}

	private fun Route.deleteImage() {
		delete<Events.Images.ImageId> { data ->
			eventImageService.deleteImage(call.user, data.imageId).onSuccess {
				call.respond(HttpStatusCode.NoContent)
			}.onFailure {
				eventImageService.handleEventExceptions(it, call)
			}
		}
	}

	private fun Route.getMetaData() {
		get<Events.Images.MetaData>(EUserScope.Admin) {
			call.respond(mapper.getMapperData())
		}
	}
}