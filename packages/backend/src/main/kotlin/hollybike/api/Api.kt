package hollybike.api

import hollybike.api.plugins.configureHTTP
import hollybike.api.plugins.configureSecurity
import hollybike.api.repository.configureDatabase
import hollybike.api.routing.controller.ApiController
import hollybike.api.routing.controller.AssociationController
import hollybike.api.routing.controller.AuthenticationController
import hollybike.api.routing.controller.UserController
import hollybike.api.services.UserService
import hollybike.api.utils.MailSender
import io.ktor.server.application.*
import io.ktor.server.plugins.callloging.*
import io.ktor.server.resources.*
import io.ktor.util.*
import org.slf4j.event.Level

val confKey = AttributeKey<Conf>("hollybikeConf")

val Attributes.conf get() = this[confKey]

fun Application.api() {
	this.attributes.put(confKey, parseConf())
	val db = configureDatabase()
	configureHTTP()
	configureSecurity(db)
	install(Resources)
	install(CallLogging) {
		this.level = Level.INFO
	}
	val userService = UserService(db)
	val mailSender = attributes.conf.smtp?.let {
		MailSender(it.url, it.port, it.username ?: "", it.password ?: "", it.sender)
	}
	ApiController(this)
	AuthenticationController(this, db)
	UserController(this, userService)
	AssociationController(this, db)
}