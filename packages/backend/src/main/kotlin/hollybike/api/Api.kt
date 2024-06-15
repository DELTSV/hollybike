package hollybike.api

import hollybike.api.database.configureDatabase
import hollybike.api.plugins.configureHTTP
import hollybike.api.plugins.configureSecurity
import hollybike.api.routing.controller.*
import hollybike.api.services.*
import hollybike.api.services.auth.AuthService
import hollybike.api.services.auth.InvitationService
import hollybike.api.services.journey.JourneyService
import hollybike.api.services.image.EventImageService
import hollybike.api.services.image.ImageMetadataService
import hollybike.api.services.storage.StorageService
import hollybike.api.services.storage.StorageServiceFactory
import hollybike.api.services.storage.signature.StorageSignatureMode
import hollybike.api.services.storage.signature.StorageSignatureService
import hollybike.api.utils.MailSender
import io.ktor.server.application.*
import io.ktor.server.plugins.callloging.*
import io.ktor.server.resources.*
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import org.jetbrains.exposed.sql.Database
import org.slf4j.event.Level
import kotlin.system.measureTimeMillis

fun Application.api(storageService: StorageService, db: Database) {
	val conf = attributes.conf

	configureHTTP()
	configureSecurity(db)
	install(Resources)
	install(CallLogging) {
		this.level = Level.INFO
	}

	val positionService = PositionService(db, CoroutineScope(Dispatchers.Default))

	val associationService = AssociationService(db, storageService)
	val userService = UserService(db, storageService, associationService)
	val invitationService = InvitationService(db)
	val authService = AuthService(db, conf.security, invitationService, userService)
	val eventService = EventService(db, storageService)
	val eventParticipationService = EventParticipationService(db, eventService)
	val imageMetadataService = ImageMetadataService()
	val eventImageService = EventImageService(db, eventService, storageService, imageMetadataService, positionService)
	val journeyService = JourneyService(db, associationService, storageService)
	val mailSender = attributes.conf.smtp?.let {
		MailSender(it.url, it.port, it.username ?: "", it.password ?: "", it.sender)
	}

//	positionService.subscribe("DummyCity") { positionData ->
//		println("Received position data in DummyCity: ${positionData.positionRequest.latitude}, ${positionData.positionRequest.longitude}, ${positionData.city}")
//	}
//
//	for (i in 0..10) {
//		positionService.push("DummyCity", i, Position(i.toDouble(), i.toDouble()))
//	}

	ApiController(this, mailSender, true)
	AuthenticationController(this, authService)
	UserController(this, userService, storageService)
	AssociationController(this, associationService, invitationService, authService)
	InvitationController(this, authService, invitationService, mailSender)
	EventController(this, eventService, eventParticipationService, associationService)
	EventParticipationController(this, eventParticipationService)
	EventImageController(this, eventImageService)
	JourneyController(this, journeyService)

	if (isOnPremise) {
		StorageController(this, storageService)
		ConfController(this, false)
	}
}