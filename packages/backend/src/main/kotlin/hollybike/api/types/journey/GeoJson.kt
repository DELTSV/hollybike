package hollybike.api.types.journey

import kotlinx.serialization.ExperimentalSerializationApi
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import kotlinx.serialization.builtins.serializer
import kotlinx.serialization.json.*

@OptIn(ExperimentalSerializationApi::class)
@JsonClassDiscriminator("type")
@Serializable
sealed class GeoJson

@Serializable
sealed class GeometryShape: GeoJson()

@Serializable
@SerialName("Point")
data class Point(
	val coordinates: GeoJsonCoordinates,
	val bbox: List<Double>? = null
): GeometryShape()

@Serializable
@SerialName("LineString")
data class LineString(
	val coordinates: List<GeoJsonCoordinates>,
	val bbox: List<Double>? = null
): GeometryShape()

@Serializable
@SerialName("Polygon")
data class Polygon(
	val coordinates: List<List<GeoJsonCoordinates>>,
	val bbox: List<Double>? = null
): GeometryShape()

@Serializable
@SerialName("MultiPoint")
data class MultiPoint(
	val coordinates: List<GeoJsonCoordinates>,
	val bbox: List<Double>? = null
): GeometryShape()

@Serializable
@SerialName("MultiLineString")
data class MultiLineString(
	val coordinates: List<List<GeoJsonCoordinates>>,
	val bbox: List<Double>? = null
): GeometryShape()

@Serializable
@SerialName("MultiPolygon")
data class MultiPolygon(
	val coordinates: List<List<List<GeoJsonCoordinates>>>,
	val bbox: List<List<List<List<GeoJsonCoordinates>>>>
): GeometryShape()

@Serializable
@SerialName("GeometryCollection")
data class GeometryCollection(
	val geometries: List<GeometryShape>,
	val bbox: List<Double>? = null
): GeoJson()

@Serializable
@SerialName("Feature")
data class Feature(
	@Serializable(with = StringOrIntSerializer::class)
	val id: String? = null,
	val properties: JsonObject?,
	val geometry: GeometryShape?,
	val bbox: List<Double>? = null,
): GeoJson()

@Serializable
@SerialName("FeatureCollection")
data class FeatureCollection(
	val features: List<GeoJson>,
	val bbox: List<Double>? = null
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