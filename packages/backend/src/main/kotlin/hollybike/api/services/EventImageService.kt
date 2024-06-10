package hollybike.api.services

import hollybike.api.exceptions.EventActionDeniedException
import hollybike.api.exceptions.EventNotFoundException
import hollybike.api.repository.*
import hollybike.api.services.storage.StorageService
import hollybike.api.types.event.image.TImageDataWithMetadata
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
	private val storageService: StorageService
) {
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

	private fun eventImagesRequest(caller: User, searchParam: SearchParam): Query {
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
			.applyParam(searchParam).andWhere {
				eventImagesCondition(caller, userParticipation)
			}
	}

	fun getImages(caller: User, searchParam: SearchParam): List<EventImage> = transaction(db) {
		EventImage.wrapRows(
			eventImagesRequest(caller, searchParam)
		).with(EventImage::owner).toList()
	}

	fun countImages(caller: User, searchParam: SearchParam): Int = transaction(db) {
		eventImagesRequest(caller, searchParam).count().toInt()
	}

	suspend fun uploadImages(
		caller: User,
		eventId: Int,
		images: List<TImageDataWithMetadata>
	): Result<List<EventImage>> {
		val foundEvent =
			eventService.getEvent(caller, eventId)
				?: return Result.failure(EventNotFoundException("Event $eventId introuvable"))

		val createdImages = transaction(db) {
			val newImages = images.map { image ->
				val uuid = UUID.randomUUID().toString()

				println(image.metadata.takenDateTime)
				println(image.metadata.position?.latitude)
				println(image.metadata.position?.longitude)
				println(image.metadata.position?.altitude)

				EventImage.new {
					owner = caller
					event = foundEvent
					path = "e/${event.id.value}/u/${owner.id.value}/$uuid"
					size = image.data.size
				} to image
			}

			runBlocking {
				newImages.forEach { (image, file) ->
					storageService.store(file.data, image.path, file.contentType)
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