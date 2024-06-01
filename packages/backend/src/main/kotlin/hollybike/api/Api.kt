package hollybike.api

import hollybike.api.database.configureDatabase
import hollybike.api.plugins.configureHTTP
import hollybike.api.plugins.configureSecurity
import hollybike.api.routing.controller.*
import hollybike.api.services.*
import hollybike.api.services.auth.AuthService
import hollybike.api.services.auth.InvitationService
import hollybike.api.services.storage.StorageService
import hollybike.api.services.storage.StorageServiceFactory
import hollybike.api.services.storage.signature.StorageSignatureMode
import hollybike.api.utils.MailSender
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

	if (!isOnPremise && storageService.signer.mode == StorageSignatureMode.JWT) {
		log.warn("JWT signature is not secure in a non-on-premise environment. Please use a secure signature mode.")
	}

	log.info("Using storage signature mode: ${storageService.signer.mode}")
	log.info("Storage service in mode ${storageService.mode} initialized in $storageInitTime ms")

	val associationService = AssociationService(db, storageService)
	val userService = UserService(db, storageService, associationService)
	val invitationService = InvitationService(db)
	val authService = AuthService(db, conf.security, invitationService, userService)
	val eventService = EventService(db, storageService)
	val eventParticipationService = EventParticipationService(db, eventService)
	val eventImageService = EventImageService(db, eventService, storageService)
	val mailSender = attributes.conf.smtp?.let {
		MailSender(it.url, it.port, it.username ?: "", it.password ?: "", it.sender)
	}

	ApiController(this, mailSender, true)
	AuthenticationController(this, authService)
	UserController(this, userService, storageService)
	AssociationController(this, associationService, invitationService, authService, storageService)
	InvitationController(this, authService, invitationService, storageService, mailSender)
	EventController(this, eventService, eventParticipationService, storageService)
	EventParticipationController(this, eventParticipationService, storageService)
	EventImageController(this, eventImageService, storageService)

	if (isOnPremise) {
		StorageController(this, storageService)
		ConfController(this, false)
	}
}