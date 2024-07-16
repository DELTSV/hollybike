/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.plugins

import io.ktor.server.application.*
import io.ktor.server.metrics.micrometer.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import io.micrometer.prometheus.PrometheusConfig
import io.micrometer.prometheus.PrometheusMeterRegistry

fun Application.configureMonitoring() {
	val appMicrometerRegistry = PrometheusMeterRegistry(PrometheusConfig.DEFAULT)

	install(MicrometerMetrics) {
		registry = appMicrometerRegistry
		// ...
	}
	routing {
		get("/metrics-micrometer") {
			call.respond(appMicrometerRegistry.scrape())
		}
	}
}
