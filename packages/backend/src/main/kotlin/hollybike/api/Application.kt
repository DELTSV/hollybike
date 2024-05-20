package hollybike.api

import io.ktor.serialization.kotlinx.json.*
import io.ktor.server.application.*
import io.ktor.server.cio.*
import io.ktor.server.engine.*
import io.ktor.server.plugins.contentnegotiation.*
import io.ktor.util.*
import kotlinx.serialization.json.Json

import generated.Constants
import hollybike.api.utils.configureRestart
import io.ktor.events.EventDefinition

var engine: ApplicationEngine? = null

fun main() {
	while (true) {
		println("Start API")
		engine = run()
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
	checkEnvironment()
	if(loadConfig()) {
		checkOnPremise()
		configureSerialization()
		api()
		frontend()
		configureRestart(false)
	} else {
		println("Starting in conf mode")
		configureSerialization()
		confMode()
		configureRestart(true)
	}

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
	val conf = parseConf(isTestEnv) ?: run {
		println("Unable to get conf from file or env")
		return false
	}
	this.attributes.put(confKey, conf)
	return true
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