package hollybike.api.routing.controller

import hollybike.api.plugins.objectPath
import hollybike.api.routing.resources.Storage
import hollybike.api.services.storage.StorageService
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.resources.*
import io.ktor.server.response.*
import io.ktor.server.routing.*

class StorageController(
	application: Application,
	private val storageService: StorageService
) {
	init {
		application.routing {
			index()

			authenticate("signed-image") {
				storage()
			}
		}
	}

	private fun Route.index() {
		get<Storage> {
			call.respondText("Bienvenue le storage de hollybike")
		}
	}

	private fun Route.storage() {
		get<Storage.Object> {
			println("ICI")
			val data = storageService.retrieve(call.objectPath) ?: return@get call.respondText(
				"Inconnu",
				status = HttpStatusCode.NotFound
			)

			call.respondBytes(data)
		}
	}
}