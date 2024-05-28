package hollybike.api.routing.controller

import hollybike.api.services.EventImageService
import hollybike.api.services.storage.StorageService
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.routing.*

class EventImageController(
	application: Application,
	private val enventImageService: EventImageService,
	private val storageService: StorageService
) {
	init {
		application.routing {
			authenticate {

			}
		}
	}
}