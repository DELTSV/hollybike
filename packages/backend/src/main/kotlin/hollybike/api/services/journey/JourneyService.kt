package hollybike.api.services.journey

import hollybike.api.ConfMapBox
import hollybike.api.exceptions.AssociationNotFound
import hollybike.api.exceptions.NotAllowedException
import hollybike.api.repository.*
import hollybike.api.services.AssociationService
import hollybike.api.services.storage.StorageService
import hollybike.api.types.journey.*
import hollybike.api.types.user.EUserScope
import hollybike.api.utils.search.Filter
import hollybike.api.utils.search.FilterMode
import hollybike.api.utils.search.SearchParam
import hollybike.api.utils.search.applyParam
import io.ktor.client.*
import io.ktor.client.engine.cio.*
import io.ktor.client.plugins.logging.*
import io.ktor.client.request.*
import io.ktor.client.statement.*
import io.ktor.http.*
import kotlinx.coroutines.runBlocking
import kotlinx.serialization.json.JsonPrimitive
import org.jetbrains.exposed.dao.load
import org.jetbrains.exposed.dao.with
import org.jetbrains.exposed.sql.Database
import org.jetbrains.exposed.sql.innerJoin
import org.jetbrains.exposed.sql.selectAll
import org.jetbrains.exposed.sql.transactions.transaction

class JourneyService(
	private val db: Database,
	private val associationService: AssociationService,
	private val storageService: StorageService,
	private val conf: ConfMapBox,
) {
	var client: HttpClient = HttpClient(CIO) {
		install(Logging) {
			level = LogLevel.INFO
		}
	}

	private fun authorizeGet(caller: User, target: Journey): Boolean = when (caller.scope) {
		EUserScope.Root -> true
		EUserScope.Admin -> caller.association.id == target.association.id
		EUserScope.User -> caller.association.id == target.association.id
	}

	private infix fun Journey?.getIfAllowed(caller: User): Journey? =
		if (this != null && authorizeGet(caller, this)) this else null

	private fun authorizeAdd(caller: User, new: TNewJourney): Boolean = when (caller.scope) {
		EUserScope.Root -> true
		EUserScope.Admin -> new.association == null || caller.association.id.value == new.association
		EUserScope.User -> new.association == null || caller.association.id.value == new.association
	}

	private fun authorizeEdit(caller: User, target: Journey): Boolean = when (caller.scope) {
		EUserScope.Root -> true
		EUserScope.Admin -> caller.association.id == target.association.id
		EUserScope.User -> caller.id == target.creator.id
	}

	fun getAll(caller: User, searchParam: SearchParam): List<Journey> {
		val param = searchParam.copy(filter = searchParam.filter.toMutableList())
		if (caller.scope not EUserScope.Root) {
			param.filter.add(Filter(Associations.id, caller.association.id.value.toString(), FilterMode.EQUAL))
		}
		return transaction(db) {
			Journey.wrapRows(
				Journeys
					.innerJoin(Associations, { Journeys.association }, { Associations.id })
					.innerJoin(Users, { Journeys.creator }, { Users.id })
					.selectAll()
					.applyParam(param)
			).with(Journey::association, Journey::creator, Journey::start, Journey::end, Journey::destination).toList()
		}
	}

	fun getAllCount(caller: User, searchParam: SearchParam): Long {
		val param = searchParam.copy(filter = searchParam.filter.toMutableList())
		if (caller.scope not EUserScope.Root) {
			param.filter.add(Filter(Associations.id, caller.association.id.value.toString(), FilterMode.EQUAL))
		}
		return transaction(db) {
			Journey.wrapRows(
				Journeys
					.innerJoin(Associations, { Journeys.association }, { Associations.id })
					.innerJoin(Users, { Journeys.creator }, { Users.id })
					.selectAll()
					.applyParam(param, false)
			).count()
		}
	}

	fun getById(caller: User, id: Int): Journey? = transaction(db) {
		Journey.findById(id)
			?.load(Journey::creator, Journey::association, Journey::start, Journey::end, Journey::destination) getIfAllowed caller
	}

	fun createJourney(caller: User, new: TNewJourney): Result<Journey> {
		if (!authorizeAdd(caller, new)) {
			return Result.failure(NotAllowedException())
		}

		val association = new.association?.let {
			associationService.getById(caller, it) ?: run {
				return Result.failure(AssociationNotFound(""))
			}
		} ?: caller.association

		val journey = transaction(db) {
			Journey.new {
				this.name = new.name
				this.association = association
				this.creator = caller
			}.load(Journey::creator, Journey::association, Journey::start, Journey::end, Journey::destination)
		}

		return Result.success(journey)
	}

	suspend fun uploadFile(
		caller: User,
		journey: Journey,
		geoJson: GeoJson,
		fileContentType: String,
	): Result<String> {
		if (!authorizeEdit(caller, journey)) {
			return Result.failure(NotAllowedException())
		}

		val path = "j/${journey.id}/f"

		storageService.store(geoJson.toJson().toByteArray(), path, fileContentType)

		transaction(db) {
			journey.file = path
			journey.totalDistance = geoJson.totalDistance.toInt()
			journey.minElevation = geoJson.minMaxAltitude?.first?.round(2)
			journey.maxElevation = geoJson.minMaxAltitude?.second?.round(2)
			journey.totalElevationGain = geoJson.totalHeightDifference.first.round(2)
			journey.totalElevationLoss = geoJson.totalHeightDifference.second.round(2)
		}

		addPreviewImage(geoJson, journey).onFailure {
			println("Failed to add preview image: $it")
		}

		return Result.success(path)
	}

	private suspend fun addPreviewImage(geoJson: GeoJson, journey: Journey): Result<Unit> {
		try {
			val imageBytes = generateUrlFromGeoJson(geoJson).getOrElse {
				return Result.failure(it)
			}

			val path = "j/${journey.id}/p"

			transaction(db) {
				journey.previewImage = path

				runBlocking {
					storageService.store(imageBytes, path, "image/png")
				}
			}

			return Result.success(Unit)
		} catch (e: Exception) {
			return Result.failure(e)
		}
	}

	suspend fun deleteJourney(caller: User, target: Journey): Boolean {
		if (!authorizeEdit(caller, target)) {
			return false
		}
		target.file?.let { storageService.delete(it) }
		transaction(db) { target.delete() }
		return true
	}

	fun setJourneyStartPosition(journey: Journey, start: Position): Journey {
		transaction(db) {
			journey.start = start
		}
		return journey
	}

	fun setJourneyEndPosition(journey: Journey, end: Position): Journey {
		transaction(db) {
			journey.end = end
		}
		return journey
	}

	fun setJourneyDestinationPosition(journey: Journey, destination: Position): Journey {
		transaction(db) {
			journey.destination = destination
		}
		return journey
	}

	private suspend fun generateUrlFromGeoJson(geoJson: GeoJson): Result<ByteArray> {
		fun encodeBoundingBox(bbox: List<Double>): String {
			require(bbox.size == 4) { "Bounding box must contain 4 elements: [minX, minY, maxX, maxY]" }

			val encodedBbox = bbox.joinToString(",")
			return "[$encodedBbox]"
		}

		val token = conf.publicAccessTokenSecret ?: run {
			return Result.failure(Exception("Mapbox public access token not found"))
		}

		val simplifiedGeoJson = geoJson
			.simplifyToUrlSafe()
			.keepLargestCoordinateElement()
			.updateGeoJsonProperties(
				"stroke",
				JsonPrimitive("#94e2d5")
			)

		val bboxURL = encodeBoundingBox(simplifiedGeoJson.getBoundingBox(withoutElevation = true))

		val response = client.get {
			url {
				protocol = URLProtocol.HTTPS
				host = "api.mapbox.com"
				path(
					"styles",
					"v1",
					"mapbox",
					"dark-v11",
					"static",
					"geojson(${simplifiedGeoJson.toJson()})",
					bboxURL,
					"500x300"
				)

				parameters.append("padding", "50,50,50,50")
				parameters.append("access_token", token)
			}
		}

		if (response.status != HttpStatusCode.OK) {
			return Result.failure(Exception("Failed to generate image from GeoJson"))
		}

		return Result.success(response.readBytes())
	}
}

