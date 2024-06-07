package hollybike.api.routing.controller

import hollybike.api.plugins.user
import hollybike.api.repository.eventMapper
import hollybike.api.repository.eventParticipationMapper
import hollybike.api.repository.userMapper
import hollybike.api.routing.resources.Events
import hollybike.api.services.EventParticipationService
import hollybike.api.services.storage.StorageService
import hollybike.api.types.event.TCreateParticipations
import hollybike.api.types.event.TEventParticipation
import hollybike.api.types.event.TUpdateImagesVisibility
import hollybike.api.types.lists.TLists
import hollybike.api.types.user.TUserPartial
import hollybike.api.utils.search.getSearchParam
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.request.*
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
				getParticipationCandidates()
				getParticipations()
				updateImageVisibility()
				addUsersToEvent()
				removeUserFromEvent()
				participateEvent()
				leaveEvent()
				promoteParticipant()
				demoteParticipant()
			}
		}
	}

	private fun Route.getParticipationCandidates() {
		get<Events.Id.Participations.Candidates> { data ->
			val searchParam = call.parameters.getSearchParam(userMapper + eventMapper + eventParticipationMapper)

			val candidates = eventParticipationService.getParticipationCandidates(
				call.user,
				data.participations.eventId.id,
				searchParam
			).getOrElse {
				eventParticipationService.handleEventExceptions(it, call)
				return@get
			}

			val count = eventParticipationService.countParticipationCandidates(
				call.user,
				data.participations.eventId.id,
				searchParam
			).getOrElse {
				eventParticipationService.handleEventExceptions(it, call)
				return@get
			}

			call.respond(
				TLists(
					data = candidates.map {
						val (user, participation) = it
						val isOwner = user.id == participation?.event?.owner?.id
						TUserPartial(user, isOwner, participation?.role, storageService.signer.sign)
					},
					page = searchParam.page,
					perPage = searchParam.perPage,
					totalPage = ceil(count.toDouble() / searchParam.perPage).toInt(),
					totalData = count
				)
			)
		}
	}

	private fun Route.getParticipations() {
		get<Events.Id.Participations> { data ->
			val searchParam = call.parameters.getSearchParam(userMapper + eventMapper + eventParticipationMapper)

			val participations = eventParticipationService.getEventParticipations(
				call.user,
				data.eventId.id,
				searchParam
			).getOrElse {
				eventParticipationService.handleEventExceptions(it, call)
				return@get
			}

			val participationCount = eventParticipationService.getEventParticipationsCount(
				call.user,
				data.eventId.id,
				searchParam
			).getOrElse {
				eventParticipationService.handleEventExceptions(it, call)
				return@get
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

	private fun Route.updateImageVisibility() {
		patch<Events.Id.Participations.ImagesVisibility> { data ->
			val update = call.receive<TUpdateImagesVisibility>()

			eventParticipationService.updateUserImageVisibility(
				call.user,
				data.participations.eventId.id,
				update.isImagesPublic
			).onSuccess {
				call.respond(TEventParticipation(it, storageService.signer.sign))
			}.onFailure {
				eventParticipationService.handleEventExceptions(it, call)
			}
		}
	}

	private fun Route.participateEvent() {
		post<Events.Id.Participations> { data ->
			eventParticipationService.participateEvent(call.user, data.eventId.id).onSuccess {
				call.respond(HttpStatusCode.Created, TEventParticipation(it, storageService.signer.sign))
			}.onFailure {
				eventParticipationService.handleEventExceptions(it, call)
			}
		}
	}

	private fun Route.removeUserFromEvent() {
		delete<Events.Id.Participations.User> { data ->
			eventParticipationService.removeUserFromEvent(call.user, data.user.eventId.id, data.userId)
				.onSuccess {
					call.respond(HttpStatusCode.OK)
				}.onFailure {
					eventParticipationService.handleEventExceptions(it, call)
				}
		}
	}

	private fun Route.addUsersToEvent() {
		post<Events.Id.Participations.AddUsers> { data ->
			val users = call.receive<TCreateParticipations>().userIds

			if (users.isEmpty()) {
				call.respond(HttpStatusCode.BadRequest, "Aucun utilisateur fourni")
				return@post
			}

			eventParticipationService.addParticipantsToEvent(call.user, data.participations.eventId.id, users)
				.onSuccess { participations ->
					call.respond(
						participations.map { TEventParticipation(it, storageService.signer.sign) }
					)
				}.onFailure {
					eventParticipationService.handleEventExceptions(it, call)
				}
		}
	}

	private fun Route.leaveEvent() {
		delete<Events.Id.Participations> { data ->
			eventParticipationService.leaveEvent(call.user, data.eventId.id).onSuccess {
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
				data.promote.user.eventId.id,
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
				data.demote.user.eventId.id,
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