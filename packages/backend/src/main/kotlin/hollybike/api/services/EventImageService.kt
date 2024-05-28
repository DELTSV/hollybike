package hollybike.api.services

import io.ktor.server.application.*
import org.jetbrains.exposed.sql.Database

class EventImageService(
	private val db: Database,
	private val eventService: EventService
) {
	suspend fun handleEventExceptions(exception: Throwable, call: ApplicationCall) =
		eventService.handleEventExceptions(exception, call)

}