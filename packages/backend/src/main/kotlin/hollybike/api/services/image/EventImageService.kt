package hollybike.api.services.image

import hollybike.api.exceptions.EventActionDeniedException
import hollybike.api.exceptions.EventNotFoundException
import hollybike.api.repository.*
import hollybike.api.services.EventService
import hollybike.api.services.PositionService
import hollybike.api.services.storage.StorageService
import hollybike.api.types.position.PositionData
import hollybike.api.types.position.PositionRequest
import hollybike.api.types.position.PositionScope
import hollybike.api.utils.search.SearchParam
import hollybike.api.utils.search.applyParam
import io.ktor.server.application.*
import kotlinx.coroutines.runBlocking
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
			handlePositionResponse(positionResponse.identifier, positionResponse.content)
		}
	}

	private fun handlePositionResponse(imageId: Int, positionData: PositionData) {
		val image = transaction(db) {
			EventImage.find {
				EventImages.id eq imageId
			}.firstOrNull()
		} ?: return

		transaction(db) {
			println("Updating position for image $imageId, ${positionData.city}")
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
		).with(EventImage::owner).toList()
	}

	fun countImages(caller: User, searchParam: SearchParam): Int = transaction(db) {
		eventImagesRequest(caller, searchParam, withPagination = false).count().toInt()
	}

	suspend fun uploadImages(
		caller: User,
		eventId: Int,
		images: List<Pair<ByteArray, String>>
	): Result<List<EventImage>> {
		val foundEvent =
			eventService.getEvent(caller, eventId)
				?: return Result.failure(EventNotFoundException("Event $eventId introuvable"))

		val createdImages = transaction(db) {
			val newImages = images.map { (data, contentType) ->
				val uuid = UUID.randomUUID().toString()

				val imageMetadata = imageMetadataService.getImageMetadata(data)
				val imageDimensions = imageMetadataService.getImageDimensions(data)
				val imageWithoutExif = imageMetadataService.removeExifData(data)

				val createdImage = EventImage.new {
					owner = caller
					event = foundEvent
					path = "e/${event.id.value}/u/${owner.id.value}/$uuid"
					size = imageWithoutExif.size
					width = imageDimensions.first
					height = imageDimensions.second
					takenDateTime = imageMetadata.takenDateTime
					latitude = imageMetadata.position?.latitude
					longitude = imageMetadata.position?.longitude
					altitude = imageMetadata.position?.altitude
				} to (imageWithoutExif to contentType)

				if (imageMetadata.position != null) {
					positionService.push(
						"images-positions", createdImage.first.id.value, PositionRequest(
							latitude = imageMetadata.position.latitude,
							longitude = imageMetadata.position.longitude,
							scope = PositionScope.Amenity
						)
					)
				}

				createdImage
			}

			runBlocking {
				newImages.forEach { (image, file) ->
					val (data, contentType) = file
					storageService.store(data, image.path, contentType)
				}
			}

			newImages
		}

		return Result.success(createdImages.map { it.first })
	}

	fun deleteImage(caller: User, imageId: Int): Result<Unit> {
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

		return Result.success(Unit)
	}
}