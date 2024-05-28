package hollybike.api.services

import hollybike.api.exceptions.EventActionDeniedException
import hollybike.api.exceptions.EventNotFoundException
import hollybike.api.repository.*
import hollybike.api.services.storage.StorageService
import hollybike.api.utils.search.SearchParam
import hollybike.api.utils.search.applyParam
import io.ktor.server.application.*
import kotlinx.coroutines.runBlocking
import org.jetbrains.exposed.dao.with
import org.jetbrains.exposed.sql.*
import org.jetbrains.exposed.sql.SqlExpressionBuilder.eq
import org.jetbrains.exposed.sql.transactions.transaction
import java.util.*

class EventImageService(
	private val db: Database,
	private val eventService: EventService,
	private val storageService: StorageService
) {
	suspend fun handleEventExceptions(exception: Throwable, call: ApplicationCall) =
		eventService.handleEventExceptions(exception, call)

	private fun eventImagesCondition(caller: User): Op<Boolean> {
		return eventService.eventUserCondition(caller) and
			(
				(
					(EventParticipations.isImagesPublic eq true) and
						(EventParticipations.user eq EventImages.owner)
					) or
					(
						(EventParticipations.isImagesPublic eq false) and
							(EventParticipations.user eq caller.id)
						)
				) and
			(Events.id eq EventImages.event) and
			(EventParticipations.event eq Events.id)
	}

	fun getImages(caller: User, searchParam: SearchParam): List<EventImage> = transaction(db) {
		EventImage.wrapRows(
			EventImages.innerJoin(Users).innerJoin(EventParticipations).innerJoin(Events).selectAll()
				.applyParam(searchParam).andWhere {
					eventImagesCondition(caller)
				}
		).with(EventImage::owner).toList()
	}

	fun countImages(caller: User, searchParam: SearchParam): Int = transaction(db) {
		EventImages.innerJoin(Users).innerJoin(EventParticipations).innerJoin(Events).selectAll()
			.applyParam(searchParam).andWhere {
				eventImagesCondition(caller)
			}.count().toInt()
	}

	suspend fun uploadImages(
		caller: User,
		eventId: Int,
		images: List<Pair<ByteArray, String>>
	): Result<List<EventImage>> {
		val foundEvent =
			eventService.getEvent(caller, eventId) ?: throw EventNotFoundException("Event $eventId introuvable")

		val createdImages = transaction(db) {
			val newImages = images.map { (data, contentType) ->
				val uuid = UUID.randomUUID().toString()

				EventImage.new {
					owner = caller
					event = foundEvent
					path = "e/${event.id.value}/u/${owner.id.value}/$uuid"
					size = data.size
				} to (data to contentType)
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
			EventImage.findById(imageId) ?: return@transaction null
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