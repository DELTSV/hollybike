/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.services.image

import hollybike.api.exceptions.EventActionDeniedException
import hollybike.api.exceptions.EventNotFoundException
import hollybike.api.repository.*
import hollybike.api.services.EventService
import hollybike.api.services.PositionService
import hollybike.api.services.storage.StorageService
import hollybike.api.types.position.TPositionRequest
import hollybike.api.types.position.EPositionScope
import hollybike.api.types.position.TImageForProcessing
import hollybike.api.types.position.TPositionResult
import hollybike.api.utils.search.Filter
import hollybike.api.utils.search.FilterMode
import hollybike.api.utils.search.SearchParam
import hollybike.api.utils.search.applyParam
import io.ktor.server.application.*
import kotlinx.coroutines.runBlocking
import org.jetbrains.exposed.dao.load
import org.jetbrains.exposed.dao.with
import org.jetbrains.exposed.sql.*
import org.jetbrains.exposed.sql.SqlExpressionBuilder.eq
import org.jetbrains.exposed.sql.SqlExpressionBuilder.isNotNull
import org.jetbrains.exposed.sql.transactions.transaction
import java.util.*

class EventImageService(
	private val db: Database,
	private val eventService: EventService,
	private val storageService: StorageService,
	private val imageMetadataService: ImageMetadataService,
	private val positionService: PositionService
) {
	init {
		positionService.subscribe("images-positions") { positionResponse ->
			if (positionResponse is TPositionResult.Success) {
				handlePositionResponse(positionResponse.identifier, positionResponse.position)
			}
		}
	}

	private fun handlePositionResponse(imageId: Int, positionData: Position) = transaction(db) {
		EventImage.findById(imageId)?.let { image ->
			image.position = positionData
		}
	}

	suspend fun handleEventExceptions(exception: Throwable, call: ApplicationCall) =
		eventService.handleEventExceptions(exception, call)

	private fun eventImagesCondition(caller: User, userParticipation: Alias<EventParticipations>): Op<Boolean> =
		EventParticipations.run {
			eventService.eventUserCondition(caller) and
				(
					(isImagesPublic eq true) or
						(
							(isImagesPublic eq false) and
								(userParticipation[role].isNotNull()) and
								(userParticipation[isJoined] eq true)
							)
					)
		}

	private fun eventImagesRequest(caller: User, searchParam: SearchParam, withPagination: Boolean = true): Query {
		val userParticipation = EventParticipations.alias("userParticipation")
		return EventImages.innerJoin(
			Users,
			{ owner },
			{ Users.id }
		).innerJoin(
			Events,
			{ Events.id },
			{ EventImages.event }
		).innerJoin(
			EventParticipations,
			{ EventParticipations.event },
			{ Events.id },
			{ EventParticipations.user eq EventImages.owner }
		).leftJoin(
			userParticipation,
			{ userParticipation[EventParticipations.event] },
			{ Events.id },
			{ userParticipation[EventParticipations.user] eq caller.id }
		).selectAll()
			.applyParam(searchParam, withPagination).andWhere {
				eventImagesCondition(caller, userParticipation)
			}
	}

	fun getImages(caller: User, searchParam: SearchParam): List<EventImage> = transaction(db) {
		EventImage.wrapRows(
			eventImagesRequest(caller, searchParam)
		).toList()
	}

	fun getImageWithDetails(caller: User, imageId: Int, searchParam: SearchParam): EventImage? = transaction(db) {
		searchParam.filter.add(Filter(EventImages.id, imageId.toString(), FilterMode.EQUAL))

		eventImagesRequest(caller, searchParam, withPagination = false).firstOrNull().let { image ->
			image?.let {
				EventImage.wrapRow(it).load(
					EventImage::owner,
					EventImage::event,
					EventImage::position,
					Event::owner,
					Event::association
				)
			}
		}
	}

	fun countImages(caller: User, searchParam: SearchParam): Long = transaction(db) {
		eventImagesRequest(caller, searchParam, withPagination = false).count()
	}

	suspend fun uploadImages(
		caller: User,
		eventId: Int,
		images: List<Pair<ByteArray, String>>
	): Result<List<EventImage>> {
		val foundEvent =
			eventService.getEvent(caller, eventId)
				?: return Result.failure(EventNotFoundException("Event $eventId introuvable"))

		val createdImages: List<TImageForProcessing> = transaction(db) {
			val newImages = images.map { (data, contentType) ->
				val uuid = UUID.randomUUID().toString()

				val imageMetadata = imageMetadataService.getImageMetadata(data)
				val imageDimensions = imageMetadataService.getImageDimensions(data)
				val imageWithoutExif = imageMetadataService.removeExifData(data)

				val createdImage = transaction(db) {
					EventImage.new {
						owner = caller
						event = foundEvent
						path = "e/${event.id.value}/u/${owner.id.value}/$uuid"
						size = imageWithoutExif.size
						width = imageDimensions.first
						height = imageDimensions.second
						takenDateTime = imageMetadata.takenDateTime
					}
				}

				TImageForProcessing(createdImage, contentType, imageWithoutExif, imageMetadata.position)
			}

			runBlocking {
				newImages.forEach { image ->
					storageService.store(image.data, image.entity.path, image.contentType)
				}
			}

			newImages
		}

		createdImages.forEach { image ->
			if (image.position != null) {
				positionService.getPositionOrPush(
					"images-positions", image.entity.id.value, TPositionRequest(
						latitude = image.position.latitude,
						longitude = image.position.longitude,
						altitude = image.position.altitude,
						scope = EPositionScope.Amenity
					)
				)
			} else {
				println("No position found for image ${image.entity.id}")
			}
		}

		return Result.success(createdImages.map { it.entity })
	}

	suspend fun deleteImage(caller: User, imageId: Int): Result<Unit> {
		val image = transaction(db) {
			EventImage.find {
				EventImages.id eq imageId
			}.with(EventImage::owner).firstOrNull() ?: return@transaction null
		} ?: return Result.failure(EventNotFoundException("Image $imageId introuvable"))

		if (image.owner.id != caller.id) {
			return Result.failure(EventActionDeniedException("Vous n'êtes pas le propriétaire de l'image"))
		}

		transaction(db) {
			image.delete()
		}

		storageService.delete(image.path)

		return Result.success(Unit)
	}
}