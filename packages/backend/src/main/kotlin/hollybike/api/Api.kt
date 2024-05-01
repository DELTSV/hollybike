package hollybike.api

import hollybike.api.plugins.configureHTTP
import hollybike.api.plugins.configureSecurity
import hollybike.api.repository.configureDatabase
import hollybike.api.routing.controller.*
import hollybike.api.services.EventService
import hollybike.api.services.UserService
import hollybike.api.services.auth.AuthService
import hollybike.api.services.auth.InvitationService
import hollybike.api.utils.MailSender
import hollybike.api.services.storage.StorageServiceFactory
import io.ktor.server.application.*
import io.ktor.server.plugins.callloging.*
import io.ktor.server.resources.*
import org.slf4j.event.Level

fun Application.api() {
	val conf = attributes.conf

	val db = configureDatabase()
	configureHTTP()
	configureSecurity(db)
	install(Resources)
	install(CallLogging) {
		this.level = Level.INFO
	}

	val storageService = StorageServiceFactory.getService(conf)

	log.info("Using ${storageService.mode} storage mode")

	val userService = UserService(db, storageService)
	val invitationService = InvitationService(db)
	val authService = AuthService(db, conf.security, invitationService)
	val eventService = EventService(db, storageService)
	val mailSender = attributes.conf.smtp?.let {
		MailSender(it.url, it.port, it.username ?: "", it.password ?: "", it.sender)
	}
	ApiController(this, mailSender)
	AuthenticationController(this, db, authService)
	UserController(this, userService)
	AssociationController(this, db, storageService)
	InvitationController(this, authService, invitationService)
	EventController(this, eventService)

	if (isOnPremise) {
		StorageController(this, storageService)
	}
}