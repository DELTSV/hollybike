package hollybike.api.services

import hollybike.api.repository.Position
import hollybike.api.repository.Positions
import hollybike.api.types.position.*

import kotlinx.coroutines.*
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.filter

import io.ktor.client.*
import io.ktor.client.call.*
import io.ktor.client.engine.cio.*
import io.ktor.client.plugins.contentnegotiation.*
import io.ktor.client.plugins.logging.*
import io.ktor.client.request.*
import io.ktor.client.statement.*
import io.ktor.http.*
import io.ktor.serialization.kotlinx.json.*
import kotlinx.serialization.json.Json
import org.jetbrains.exposed.sql.Database
import org.jetbrains.exposed.sql.and
import org.jetbrains.exposed.sql.transactions.transaction

class PositionService(
	private val db: Database,
	private val scope: CoroutineScope
) {
	var client: HttpClient = HttpClient(CIO) {
		install(Logging) {
			level = LogLevel.INFO
		}
		install(ContentNegotiation) {
			json(Json {
				prettyPrint = true
				ignoreUnknownKeys = true
			})
		}
	}

	private val messageChannel = Channel<TPositionMessage>()
	private val subscribers = MutableSharedFlow<TPositionResponse>(replay = 0)

	init {
		scope.launch {
			while (isActive) {
				delay(1200L)
				val message = messageChannel.tryReceive().getOrNull()
				if (message != null) {
					processMessage(message)
				}
			}
		}
	}

	private fun push(topic: String, identifier: Int, content: TPositionRequest) {
		val message = TPositionMessage(topic, identifier, content)
		scope.launch {
			messageChannel.send(message)
		}
	}

	fun getPositionOrPush(topic: String, identifier: Int, content: TPositionRequest) {
		val position = getPositionFromCoordinates(content.latitude, content.longitude)

		if (position == null) {
			push(topic, identifier, content)
		} else {
			scope.launch {
				subscribers.emit(TPositionResponse(topic, identifier, position))
			}
		}
	}

	fun subscribe(topic: String, consumer: (TPositionResponse) -> Unit) {
		scope.launch {
			subscribers
				.filter { it.topic == topic }
				.collect { positionData ->
					consumer(positionData)
				}
		}
	}

	private fun getPositionFromCoordinates(latitude: Double, longitude: Double): Position? = transaction(db) {
		val tolerance = 0.0001
		Position.find {
			(Positions.latitude greaterEq latitude - tolerance) and
				(Positions.latitude lessEq latitude + tolerance) and
				(Positions.longitude greaterEq longitude - tolerance) and
				(Positions.longitude lessEq longitude + tolerance)
		}.firstOrNull()
	}

	private fun processMessage(message: TPositionMessage) {
		scope.launch {
			val positionData = getPositionData(message.content)
			subscribers.emit(TPositionResponse(message.topic, message.identifier, positionData))
		}
	}

	private suspend fun fetch(positionRequest: TPositionRequest): TPlaceResponse {
		val response: HttpResponse = client.get {
			url {
				protocol = URLProtocol.HTTPS
				host = "nominatim.openstreetmap.org"
				path("reverse")
				parameters.append("lat", positionRequest.latitude.toString())
				parameters.append("lon", positionRequest.longitude.toString())
				parameters.append("zoom", "18")
				parameters.append("format", "jsonv2")
				parameters.append("accept-language", "fr")
			}
			accept(ContentType.Application.Json)
		}
		return response.body()
	}

	private fun getPositionData(positionRequest: TPositionRequest): Position {
		getPositionFromCoordinates(
			positionRequest.latitude,
			positionRequest.longitude
		).let {
			if (it != null) {
				return it
			}
		}

		val response = runBlocking { fetch(positionRequest) }

		val city = response.address.city
			?: response.address.town
			?: response.address.village
			?: response.address.hamlet
			?: response.address.municipality
			?: response.address.county

		return transaction(db) {
			Position.new {
				latitude = positionRequest.latitude
				longitude = positionRequest.longitude
				altitude = positionRequest.altitude
				placeType = response.type
				placeName = response.name.let { it.ifBlank { null } }
				cityName = city.let { if (response.address.suburb != null) "$it, ${response.address.suburb}" else it }
				countryName = response.address.country
				countyName = response.address.county
				stateName = response.address.state ?: response.address.region
			}
		}
	}
}


