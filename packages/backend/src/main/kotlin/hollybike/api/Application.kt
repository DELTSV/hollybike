/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api

import io.ktor.serialization.kotlinx.json.*
import io.ktor.server.application.*
import io.ktor.server.cio.*
import io.ktor.server.engine.*
import io.ktor.server.plugins.contentnegotiation.*
import io.ktor.util.*
import kotlinx.serialization.json.Json

import generated.Constants
import hollybike.api.database.configureDatabase
import hollybike.api.services.storage.StorageInitException
import hollybike.api.services.storage.StorageService
import hollybike.api.services.storage.StorageServiceFactory
import hollybike.api.services.storage.signature.StorageSignatureMode
import hollybike.api.services.storage.signature.StorageSignatureService
import hollybike.api.utils.configureRestart
import io.ktor.util.logging.*
import kotlin.math.log
import kotlin.system.measureTimeMillis

lateinit var signatureService: StorageSignatureService

lateinit var logger: Logger

fun main() {
	while (true) {
		println("Start API")
		run()
		println("Stopping API")
	}
}

fun run(isTestEnv: Boolean = false): ApplicationEngine {
	return embeddedServer(
		CIO,
		port = System.getProperty("port")?.toInt() ?: 8080,
		host = "0.0.0.0",
		watchPaths = listOf("classes", "resources"),
		module = Application::module,
	).apply {
		environment.monitor.subscribe(ApplicationStopPreparing) {
			stop()
		}
	}.start(wait = !isTestEnv)
}

fun Application.module() {
	logger = log
	checkEnvironment()
	checkOnPremise()
	if(!loadConfig()) {
		return setupFailover()
	}
	val storageService = loadStorage() ?: return setupFailover()

	val db = configureDatabase() ?: return setupFailover()

	configureSerialization()
	api(storageService, db)
	frontend()
	configureRestart(false)

	log.info("Running hollyBike API in ${if (Constants.IS_ON_PREMISE) "on-premise" else "cloud"} mode")
}

fun Application.configureSerialization() {
	install(ContentNegotiation) {
		json(Json {
			prettyPrint = true
			ignoreUnknownKeys = true
		})
	}
}

fun Application.checkEnvironment() {
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

fun Application.loadConfig(): Boolean {
	val conf = parseConf() ?: run {
		println("Unable to get conf from file or env")
		return false
	}
	this.attributes.put(confKey, conf)
	return true
}

fun Application.loadStorage(): StorageService? {
	return try {
		val storageService: StorageService
		val storageInitTime = measureTimeMillis {
			storageService = StorageServiceFactory.getService(attributes.conf, isOnPremise)
		}
		log.info("Using storage signature mode: ${storageService.signer.mode}")
		log.info("Storage service in mode ${storageService.mode} initialized in $storageInitTime ms")

		signatureService = storageService.signer

		if (!isOnPremise && storageService.signer.mode == StorageSignatureMode.JWT) {
			log.warn("JWT signature is not secure in a non-on-premise environment. Please use a secure signature mode.")
		}

		storageService
	}catch (e: StorageInitException) {
		log.error(e.message)
		null
	}
}

fun Application.setupFailover() {
	if(isOnPremise) {
		println("Starting in conf mode")
		configureSerialization()
		confMode()
		configureRestart(true)
		frontend()
	} else {
		println("Cannot start API")
	}
}

fun Application.loadCustomConfig(customConfig: Conf) {
	this.attributes.put(confKey, customConfig)
}

fun Application.checkOnPremise() {
	attributes.put(onPremiseAttributeKey, Constants.IS_ON_PREMISE)
}

fun Application.forceMode(isOnPremise: Boolean) {
	attributes.put(onPremiseAttributeKey, isOnPremise)
}

val Application.isTestEnv: Boolean get() = attributes[isTestEnvAttributeKey]
val Application.isOnPremise: Boolean get() = attributes[onPremiseAttributeKey]
val Application.isCloud: Boolean get() = !isOnPremise

private val onPremiseAttributeKey = AttributeKey<Boolean>("onPremise")
private val isTestEnvAttributeKey = AttributeKey<Boolean>("isTestEnv")