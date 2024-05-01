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
	run()
}

fun run(isTestEnv: Boolean = false): ApplicationEngine {
	if (isTestEnv) {
		System.setProperty("aws.accessKeyId","minio-root-user")
		System.setProperty("aws.secretAccessKey","minio-root-password")
	}

	return embeddedServer(
		CIO,
		port = 8080,
		host = "0.0.0.0",
		watchPaths = listOf("classes", "resources"),
		module = Application::module
	).start(wait = !isTestEnv)
}

fun Application.module() {
	loadConfig()
	checkTestEnvironement()
	checkOnPremise()
	configureSerialization()
	api()

	log.info("Running hollyBike API in ${if (Constants.IS_ON_PREMISE) "on-premise" else "cloud"} mode")

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

fun Application.checkTestEnvironement() {
	log.info("Checking environment...")

	attributes.put(isTestEnvAttributeKey, System.getProperty("is_test_env")?.let {
		if (it == "true") {
			log.info("Running in test environment")
			true
		} else {
			if (developmentMode) {
				log.info("Running in development environment")
			} else {
				log.info("Running in production environment")
			}

			false
		}
	} ?: false)
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

val Application.isTestEnv: Boolean get() = attributes[isTestEnvAttributeKey]
val Application.isOnPremise: Boolean get() = attributes[onPremiseAttributeKey]
val Application.isCloud: Boolean get() = !isOnPremise

private val onPremiseAttributeKey = AttributeKey<Boolean>("onPremise")
private val isTestEnvAttributeKey = AttributeKey<Boolean>("isTestEnv")