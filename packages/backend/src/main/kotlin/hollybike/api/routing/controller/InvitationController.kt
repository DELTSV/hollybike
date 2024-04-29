package hollybike.api.routing.controller

import hollybike.api.plugins.user
import hollybike.api.routing.resources.Invitation
import hollybike.api.services.auth.AuthService
import hollybike.api.services.auth.InvitationService
import hollybike.api.types.invitation.TInvitation
import hollybike.api.types.user.EUserScope
import hollybike.api.utils.get
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.response.*
import io.ktor.server.routing.*

class InvitationController(
	application: Application,
	private val authService: AuthService,
	private val invitationService: InvitationService
) {
	init {
		application.routing {
			authenticate {
				listInvitations()
			}
		}
	}

	private fun Route.listInvitations() {
		get<Invitation>(EUserScope.Admin) {
			val host = call.request.headers["Host"]!!
			invitationService.listInvitation(call.user, call.user.association).onSuccess {
				val dto = it.map { i ->
					TInvitation(i, authService.generateLink(call.user, host, i.role, i.association.id.value)!!)
				}
				call.respond(dto)
			}
		}
	}
}