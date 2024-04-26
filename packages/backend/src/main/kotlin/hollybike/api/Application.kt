package hollybike.api

import io.ktor.serialization.kotlinx.json.*
import io.ktor.server.application.*
import io.ktor.server.cio.*
import io.ktor.server.engine.*
import io.ktor.server.plugins.contentnegotiation.*
import io.ktor.util.*
import kotlinx.serialization.json.Json

import generated.Constants

fun main() {
	embeddedServer(
		CIO,
		port = 8080,
		host = "0.0.0.0",
		watchPaths = listOf("classes", "resources"),
		module = Application::module
	).start(wait = true)
}

fun Application.module() {
	loadConfig()
	checkOnPremise()
	configureSerialization()
	api()

	log.info("Running hollybike API in ${if (Constants.IS_ON_PREMISE) "on-premise" else "cloud"} mode")

	if (isOnPremise) {
		frontend()
	}
}

fun Application.configureSerialization() {
	install(ContentNegotiation) {
		json(Json {
			prettyPrint = true
			ignoreUnknownKeys = true
		})
	}
}

fun Application.loadConfig() {
	this.attributes.put(confKey, parseConf())
}

fun Application.checkOnPremise() {
	attributes.put(onPremiseAttributeKey, Constants.IS_ON_PREMISE)

	if (!isOnPremise) {
		val conf = attributes.conf

		if (conf.storage.s3BucketName == null) {
			throw IllegalStateException("Missing storage.s3BucketName in configuration for production mode")
		}
	}
}

val Application.isOnPremise: Boolean get() = attributes[onPremiseAttributeKey]
val Application.isCloud: Boolean get() = !isOnPremise

private val onPremiseAttributeKey = AttributeKey<Boolean>("onPremise")