package hollybike.api.types.journey

import aws.smithy.kotlin.runtime.util.type
import kotlinx.serialization.ExperimentalSerializationApi
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import kotlinx.serialization.builtins.serializer
import kotlinx.serialization.json.*
import kotlin.coroutines.coroutineContext
import kotlin.math.max
import kotlin.math.min

@OptIn(ExperimentalSerializationApi::class)
@JsonClassDiscriminator("type")
@Serializable
sealed class GeoJson(
	var bbox: List<Double>? = null,
)

@Serializable
sealed class GeometryShape: GeoJson()

@Serializable
@SerialName("Point")
data class Point(
	val coordinates: GeoJsonCoordinates
): GeometryShape()

@Serializable
@SerialName("LineString")
data class LineString(
	val coordinates: List<GeoJsonCoordinates>
): GeometryShape()

@Serializable
@SerialName("Polygon")
data class Polygon(
	val coordinates: List<List<GeoJsonCoordinates>>
): GeometryShape()

@Serializable
@SerialName("MultiPoint")
data class MultiPoint(
	val coordinates: List<GeoJsonCoordinates>
): GeometryShape()

@Serializable
@SerialName("MultiLineString")
data class MultiLineString(
	val coordinates: List<List<GeoJsonCoordinates>>
): GeometryShape()

@Serializable
@SerialName("MultiPolygon")
data class MultiPolygon(
	val coordinates: List<List<List<GeoJsonCoordinates>>>
): GeometryShape()

@Serializable
@SerialName("GeometryCollection")
data class GeometryCollection(
	val geometries: List<GeometryShape>
): GeoJson()

@Serializable
@SerialName("Feature")
data class Feature(
	@Serializable(with = StringOrIntSerializer::class)
	val id: String? = null,
	val properties: JsonObject?,
	val geometry: GeometryShape?
): GeoJson()

@Serializable
@SerialName("FeatureCollection")
data class FeatureCollection(
	val features: List<GeoJson>
): GeoJson()

typealias GeoJsonCoordinates = List<Double>

object StringOrIntSerializer: JsonTransformingSerializer<String>(String.serializer()) {
	override fun transformDeserialize(element: JsonElement): JsonElement =
		if(element is JsonPrimitive && element.intOrNull != null) {
			JsonPrimitive(element.int.toString())
		} else {
			element
		}
}

fun GeoJson.getBoundingBox(): List<Double> {
	val list = if(isElevated) {
		val bbox = listOf(Double.POSITIVE_INFINITY, Double.POSITIVE_INFINITY, Double.POSITIVE_INFINITY, Double.NEGATIVE_INFINITY, Double.NEGATIVE_INFINITY, Double.NEGATIVE_INFINITY)
		getCoordinateDump().fold(bbox) { a, b ->
			listOf(
				min(b[0], a[0]),
				min(b[1], a[1]),
				min(b[2], a[2]),
				max(b[0], a[3]),
				max(b[1], a[4]),
				max(b[2], a[5])
			)
		}
	} else {
		val bbox = listOf(Double.POSITIVE_INFINITY, Double.POSITIVE_INFINITY, Double.NEGATIVE_INFINITY, Double.NEGATIVE_INFINITY)
		getCoordinateDump().fold(bbox) { a, b ->
			listOf(
				min(b[0], a.myGet(0)),
				min(b[1], a.myGet(1)),
				max(b[0], a.myGet(2)),
				max(b[1], a.myGet(3)),
			)
		}
	}
	return if(list.any { it.isInfinite() }) {
		if(list.size == 6) {
			list.take(3) + list.take(3)
		} else {
			list.take(2) + list.take(2)
		}
	} else {
		list
	}
}

private fun GeoJson.getCoordinateDump(): List<GeoJsonCoordinates> {
	return when(this) {
		is Point -> listOf(coordinates)
		is LineString -> coordinates
		is MultiPoint -> coordinates
		is Polygon -> coordinates.reduce { a, b -> a + b }
		is MultiLineString -> coordinates.reduce { a, b -> a + b}
		is MultiPolygon -> coordinates.fold(listOf()) { a, b -> a + b.reduce { c, d -> c + d}}
		is Feature -> geometry?.getCoordinateDump() ?: listOf()
		is GeometryCollection -> geometries.fold(listOf()) { a, b -> a + b.getCoordinateDump() }
		is FeatureCollection -> features.fold(listOf()) { a, b -> a + b.getCoordinateDump() }
	}
}

private val GeoJson.isElevated: Boolean
	get() = when(this) {
		is Point -> coordinates.size == 3
		is LineString -> coordinates.any { it.size == 3 }
		is MultiPoint -> coordinates.any { it.size == 3 }
		is Polygon -> coordinates.any { it.any { coord -> coord.size == 3 } }
		is MultiLineString -> coordinates.any { it.any { coord -> coord.size == 3 } }
		is MultiPolygon -> coordinates.any { polyCoord -> polyCoord.any { it.any { coord -> coord.size == 3 } } }
		is Feature -> geometry?.isElevated == true
		is GeometryCollection -> geometries.any { it.isElevated }
		is FeatureCollection -> features.any { it.isElevated }
	}

private fun List<Double>.myGet(index: Int): Double = getOrNull(index) ?: 0.0