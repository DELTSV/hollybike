package hollybike.api

import hollybike.api.plugins.configureHTTP
import hollybike.api.plugins.configureSecurity
import hollybike.api.repository.configureDatabase
import hollybike.api.routing.controller.*
import hollybike.api.services.AssociationService
import hollybike.api.services.EventService
import hollybike.api.services.UserService
import hollybike.api.services.auth.AuthService
import hollybike.api.services.auth.InvitationService
import hollybike.api.services.storage.StorageService
import hollybike.api.utils.MailSender
import hollybike.api.services.storage.StorageServiceFactory
import io.ktor.server.application.*
import io.ktor.server.plugins.callloging.*
import io.ktor.server.resources.*
import org.slf4j.event.Level
import kotlin.system.measureTimeMillis

fun Application.api() {
	val conf = attributes.conf

	val db = configureDatabase()
	configureHTTP()
	configureSecurity(db)
	install(Resources)
	install(CallLogging) {
		this.level = Level.INFO
	}

	val storageService: StorageService
	val storageInitTime = measureTimeMillis {
		storageService = StorageServiceFactory.getService(conf, isOnPremise)
	}

	log.info("Storage service in mode ${storageService.mode} initialized in $storageInitTime ms")

	val associationService = AssociationService(db, storageService)
	val userService = UserService(db, storageService, associationService)
	val invitationService = InvitationService(db)
	val authService = AuthService(db, conf.security, invitationService, userService)
	val eventService = EventService(db, storageService)
	val mailSender = attributes.conf.smtp?.let {
		MailSender(it.url, it.port, it.username ?: "", it.password ?: "", it.sender)
	}
	ApiController(this, mailSender, true)
	AuthenticationController(this, authService)
	UserController(this, userService)
	AssociationController(this, associationService, invitationService, authService)
	InvitationController(this, authService, invitationService)
	EventController(this, eventService)

	if (isOnPremise) {
		StorageController(this, storageService)
		ConfController(this, false)
	}
}