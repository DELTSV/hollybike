package hollybike.api.routing.controller

import hollybike.api.plugins.user
import hollybike.api.repository.eventMapper
import hollybike.api.repository.userMapper
import hollybike.api.routing.resources.Events
import hollybike.api.services.EventParticipationService
import hollybike.api.services.storage.StorageService
import hollybike.api.types.event.TEventParticipation
import hollybike.api.types.lists.TLists
import hollybike.api.utils.search.getSearchParam
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.resources.*
import io.ktor.server.resources.post
import io.ktor.server.response.*
import io.ktor.server.routing.Route
import io.ktor.server.routing.routing
import kotlin.math.ceil

class EventParticipationController(
	application: Application,
	private val eventParticipationService: EventParticipationService,
	private val storageService: StorageService,
) {
	init {
		application.routing {
			authenticate {
				getParticipations()
				participateEvent()
				leaveEvent()
				promoteParticipant()
				demoteParticipant()
			}
		}
	}

	private fun Route.getParticipations() {
		post<Events.Id.Participations> { data ->
			val searchParam = call.parameters.getSearchParam(userMapper + eventMapper)

			val participations = eventParticipationService.getEventParticipations(
				call.user,
				data.participations.id,
				searchParam
			).getOrElse {
				eventParticipationService.handleEventExceptions(it, call)
				return@post
			}

			val participationCount = eventParticipationService.getEventCount(
				call.user,
				data.participations.id
			).getOrElse {
				eventParticipationService.handleEventExceptions(it, call)
				return@post
			}

			call.respond(
				TLists(
					data = participations.map { TEventParticipation(it, storageService.signer.sign) },
					page = searchParam.page,
					perPage = searchParam.perPage,
					totalPage = ceil(participationCount.toDouble() / searchParam.perPage).toInt(),
					totalData = participationCount
				)
			)
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
			eventParticipationService.promoteParticipant(
				call.user,
				data.promote.user.participations.id,
				data.promote.userId
			)
				.onSuccess {
					call.respond(HttpStatusCode.OK, TEventParticipation(it, storageService.signer.sign))
				}.onFailure {
					eventParticipationService.handleEventExceptions(it, call)
				}
		}
	}

	private fun Route.demoteParticipant() {
		patch<Events.Id.Participations.User.Demote> { data ->
			eventParticipationService.demoteParticipant(
				call.user,
				data.demote.user.participations.id,
				data.demote.userId
			)
				.onSuccess {
					call.respond(HttpStatusCode.OK, TEventParticipation(it, storageService.signer.sign))
				}.onFailure {
					eventParticipationService.handleEventExceptions(it, call)
				}
		}
	}
}