package hollybike.api.routing.controller

import hollybike.api.plugins.user
import hollybike.api.routing.resources.Events
import hollybike.api.services.EventParticipationService
import hollybike.api.services.storage.StorageService
import hollybike.api.types.event.TEventParticipation
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.resources.*
import io.ktor.server.response.*
import io.ktor.server.resources.post
import io.ktor.server.routing.Route
import io.ktor.server.routing.routing

class EventParticipationController(
	application: Application,
	private val eventParticipationService: EventParticipationService,
	private val storageService: StorageService,
) {
	init {
		application.routing {
			authenticate {
				participateEvent()
				leaveEvent()
				promoteParticipant()
				demoteParticipant()
			}
		}
	}

	private fun Route.participateEvent() {
		post<Events.Id.Participations> { data ->
			eventParticipationService.participateEvent(call.user, data.participations.id).onSuccess {
				call.respond(HttpStatusCode.Created, TEventParticipation(it, storageService.signer.sign))
			}.onFailure {
				eventParticipationService.handleEventExceptions(it, call)
			}
		}
	}

	private fun Route.leaveEvent() {
		delete<Events.Id.Participations> { data ->
			eventParticipationService.leaveEvent(call.user, data.participations.id).onSuccess {
				call.respond(HttpStatusCode.OK)
			}.onFailure {
				eventParticipationService.handleEventExceptions(it, call)
			}
		}
	}

	private fun Route.promoteParticipant() {
		patch<Events.Id.Participations.User.Promote> { data ->
			eventParticipationService.promoteParticipant(call.user, data.promote.user.participations.id, data.promote.userId)
				.onSuccess {
					call.respond(HttpStatusCode.OK, TEventParticipation(it, storageService.signer.sign))
				}.onFailure {
					eventParticipationService.handleEventExceptions(it, call)
				}
		}
	}

	private fun Route.demoteParticipant() {
		patch<Events.Id.Participations.User.Demote> { data ->
			eventParticipationService.demoteParticipant(call.user, data.demote.user.participations.id, data.demote.userId)
				.onSuccess {
					call.respond(HttpStatusCode.OK, TEventParticipation(it, storageService.signer.sign))
				}.onFailure {
					eventParticipationService.handleEventExceptions(it, call)
				}
		}
	}
}