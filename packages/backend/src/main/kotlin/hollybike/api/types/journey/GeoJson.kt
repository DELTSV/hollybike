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

