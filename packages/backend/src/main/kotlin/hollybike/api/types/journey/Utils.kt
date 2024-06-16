package hollybike.api.types.journey

import kotlin.math.max
import kotlin.math.min

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
				min(b[0], a[0]),
				min(b[1], a[1]),
				max(b[0], a[2]),
				max(b[1], a[3]),
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

val GeoJson.start: GeoJsonCoordinates?
	get() = when(this) {
		is Point -> coordinates
		is MultiPoint -> coordinates[0]
		is LineString -> coordinates[0]
		is MultiLineString -> coordinates[0][0]
		is Polygon -> null
		is MultiPolygon -> null
		is Feature -> geometry?.start
		is FeatureCollection -> features.firstOrNull()?.start
		is GeometryCollection -> geometries.firstOrNull()?.start
	}

val GeoJson.end: GeoJsonCoordinates?
	get() = when(this) {
		is Point -> null
		is MultiPoint -> coordinates.last()
		is LineString -> coordinates.last()
		is MultiLineString -> coordinates.last().last()
		is Polygon -> null
		is MultiPolygon -> null
		is Feature -> geometry?.end
		is FeatureCollection -> features.firstOrNull()?.end
		is GeometryCollection -> geometries.firstOrNull()?.end
	}