package hollybike.api.routing.controller

import hollybike.api.exceptions.AssociationNotFound
import hollybike.api.exceptions.InvitationAlreadyExist
import hollybike.api.exceptions.NotAllowedException
import hollybike.api.plugins.user
import hollybike.api.routing.resources.Invitation
import hollybike.api.services.auth.AuthService
import hollybike.api.services.auth.InvitationService
import hollybike.api.types.invitation.EInvitationStatus
import hollybike.api.types.invitation.TInvitation
import hollybike.api.types.invitation.TInvitationCreation
import hollybike.api.types.user.EUserScope
import hollybike.api.utils.MailSender
import hollybike.api.utils.get
import hollybike.api.utils.patch
import hollybike.api.utils.post
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.request.*
import io.ktor.server.resources.post
import io.ktor.server.response.*
import io.ktor.server.routing.*

class InvitationController(
	application: Application,
	private val authService: AuthService,
	private val invitationService: InvitationService,
	private val mailSender: MailSender?
) {
	init {
		application.routing {
			authenticate {
				listInvitations()
				createInvitation()
				disableInvitation()
				sendLinkMail()
			}
		}
	}

	private fun Route.listInvitations() {
		get<Invitation>(EUserScope.Admin) {
			val host = call.request.headers["Host"]!!
			invitationService.listInvitation(call.user, call.user.association).onSuccess {
				val dto = it.map { i ->
					if(i.status == EInvitationStatus.Enabled) {
						TInvitation(i, authService.generateLink(call.user, host, i))
					} else {
						TInvitation(i)
					}
				}
				call.respond(dto)
			}
		}
	}

	private fun Route.createInvitation() {
		post<Invitation>(EUserScope.Admin) {
			val host = call.request.headers["Host"]!!
			val invitationCreation = call.receive<TInvitationCreation>()
			invitationService.createInvitation(
				call.user,
				invitationCreation.role,
				invitationCreation.association ?: call.user.association.id.value,
				invitationCreation.maxUses,
				invitationCreation.expiration
			).onSuccess {
				call.respond(TInvitation(it, authService.generateLink(call.user, host, it)))
			}.onFailure {
				when(it) {
					is NotAllowedException -> call.respond(HttpStatusCode.Forbidden)
					is AssociationNotFound -> call.respond(HttpStatusCode.NotFound, "Association inconnue")
					is InvitationAlreadyExist -> call.respond(HttpStatusCode.Conflict, "Une invitation avec ces paramètres existe déjà")
					else -> {
						it.printStackTrace()
						call.respond(HttpStatusCode.InternalServerError)
					}
				}
			}
		}
	}

	private fun Route.disableInvitation() {
		patch<Invitation.Id.Disable>(EUserScope.Admin) {
			invitationService.disableInvitation(call.user, it.id.id).onSuccess {  i ->
				call.respond(TInvitation(i))
			}.onFailure {  e ->
				when(e) {
					is NotAllowedException -> call.respond(HttpStatusCode.Forbidden)
					is AssociationNotFound -> call.respond(HttpStatusCode.NotFound, "Association inconnue")
					else -> {
						e.printStackTrace()
						call.respond(HttpStatusCode.InternalServerError)
					}
				}
			}
		}
	}

	private fun Route.sendLinkMail() {
		post<Invitation.Id.SendMail> {
			if(mailSender == null) {
				call.respond(HttpStatusCode.ServiceUnavailable, "Aucun serveur SMTP n'est configurer")
				return@post
			}
			val to = call.request.queryParameters["to"] ?: run {
				call.respond(HttpStatusCode.BadRequest, "Aucun destinataire")
				return@post
			}
			val host = call.request.headers["Host"] ?: run {
				call.respond(HttpStatusCode.BadRequest, "Aucun Host")
				return@post
			}
			val invitation = invitationService.getValidInvitation(it.id.id) ?: run {
				call.respond(HttpStatusCode.NotFound, "Aucune invitation valide")
				return@post
			}
			if(mailSender.sendLinkMail(to, call.user.username, host, authService.generateLink(call.user, host, invitation))) {
				call.respond(HttpStatusCode.OK)
			} else {
				println("error")
				call.respond(HttpStatusCode.InternalServerError)
			}
		}
	}
}