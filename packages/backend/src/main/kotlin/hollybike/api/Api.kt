package hollybike.api

import hollybike.api.plugins.configureHTTP
import hollybike.api.plugins.configureSecurity
import hollybike.api.repository.configureDatabase
import hollybike.api.routing.controller.*
import hollybike.api.services.UserService
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

	val storageService = StorageServiceFactory.getService(
		conf,
		developmentMode,
		isOnPremise
	)

	log.info("Using ${storageService.mode} storage mode")

	val userService = UserService(db, storageService)
	val mailSender = attributes.conf.smtp?.let {
		MailSender(it.url, it.port, it.username ?: "", it.password ?: "", it.sender)
	}
	ApiController(this)
	AuthenticationController(this, db)
	UserController(this, userService)
	AssociationController(this, db)

	if (isOnPremise) {
		StorageController(this, storageService)
	}
}