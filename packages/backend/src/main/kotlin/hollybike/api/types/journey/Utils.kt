package hollybike.api.types.journey

import kotlin.math.*

fun GeoJson.getBoundingBox(withoutElevation: Boolean = false): List<Double> {
	val list = if (isElevated && !withoutElevation) {
		val bbox = listOf(
			Double.POSITIVE_INFINITY, Double.POSITIVE_INFINITY, Double.POSITIVE_INFINITY,
			Double.NEGATIVE_INFINITY, Double.NEGATIVE_INFINITY, Double.NEGATIVE_INFINITY
		)
		getCoordinateDump().fold(bbox) { a, b ->
			if (b.size >= 3) {
				listOf(
					min(b[0], a[0]),
					min(b[1], a[1]),
					min(b[2], a[2]),
					max(b[0], a[3]),
					max(b[1], a[4]),
					max(b[2], a[5])
				)
			} else {
				a
			}
		}
	} else {
		val bbox = listOf(
			Double.POSITIVE_INFINITY, Double.POSITIVE_INFINITY,
			Double.NEGATIVE_INFINITY, Double.NEGATIVE_INFINITY
		)
		getCoordinateDump().fold(bbox) { a, b ->
			if (b.size >= 2) {
				listOf(
					min(b[0], a[0]),
					min(b[1], a[1]),
					max(b[0], a[2]),
					max(b[1], a[3])
				)
			} else {
				a
			}
		}
	}

	return if (list.any { it.isInfinite() }) {
		if (list.size == 6) {
			list.take(3) + list.take(3)
		} else {
			list.take(2) + list.take(2)
		}
	} else {
		list
	}
}

fun GeoJson.getCoordinateDump(): List<GeoJsonCoordinates> {
	return when (this) {
		is Point -> listOf(coordinates)
		is LineString -> coordinates
		is MultiPoint -> coordinates
		is Polygon -> coordinates.reduce { a, b -> a + b }
		is MultiLineString -> coordinates.reduce { a, b -> a + b }
		is MultiPolygon -> coordinates.fold(listOf()) { a, b -> a + b.reduce { c, d -> c + d } }
		is Feature -> geometry?.getCoordinateDump() ?: listOf()
		is GeometryCollection -> geometries.fold(listOf()) { a, b -> a + b.getCoordinateDump() }
		is FeatureCollection -> features.fold(listOf()) { a, b -> a + b.getCoordinateDump() }
	}
}

private fun GeoJson.countCoordinates(): Int {
	return getCoordinateDump().size
}

fun GeoJson.keepLargestCoordinateElement(): GeoJson {
	return when (this) {
		is FeatureCollection -> {
			val largestFeature = features.maxByOrNull { it.countCoordinates() }
			if (largestFeature != null) {
				this.copy(features = listOf(largestFeature))
			} else {
				this
			}
		}

		is GeometryCollection -> {
			val largestGeometry = geometries.maxByOrNull { it.countCoordinates() }
			if (largestGeometry != null) {
				this.copy(geometries = listOf(largestGeometry))
			} else {
				this
			}
		}

		else -> this
	}
}

private val GeoJson.isBboxElevated: Boolean
	get() = bbox?.size == 6

val GeoJson.minMaxAltitude: Pair<Double, Double>?
	get() {
		return if (isBboxElevated && bbox != null) {
			bbox?.let {
				Pair(it[2], it[5])
			}
		} else {
			null
		}
	}

private val GeoJson.isElevated: Boolean
	get() = when (this) {
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
	get() = when (this) {
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
	get() = when (this) {
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

private const val EARTH_RADIUS_METERS = 6371000.0

val GeoJson.totalDistance: Double
	get() = when (this) {
	is Point -> 0.0 // A single point has no distance
	is LineString -> calculateDistance(coordinates)
	is MultiPoint -> calculateDistance(coordinates)
	is Polygon -> coordinates.sumOf { calculateDistance(it) }
	is MultiLineString -> coordinates.sumOf { calculateDistance(it) }
	is MultiPolygon -> coordinates.sumOf { poly -> poly.sumOf { calculateDistance(it) } }
	is Feature -> geometry?.totalDistance ?: 0.0
	is GeometryCollection -> geometries.sumOf { it.totalDistance }
	is FeatureCollection -> features.sumOf { it.totalDistance }
}


private fun calculateDistance(coords: List<GeoJsonCoordinates>): Double {
	if (coords.size < 2) return 0.0
	var totalDistance = 0.0
	for (i in 0 until coords.size - 1) {
		totalDistance += haversineDistance(coords[i], coords[i + 1])
	}
	return totalDistance
}

private fun haversineDistance(coord1: GeoJsonCoordinates, coord2: GeoJsonCoordinates): Double {
	val lat1 = coord1[1].toRadians()
	val lon1 = coord1[0].toRadians()
	val lat2 = coord2[1].toRadians()
	val lon2 = coord2[0].toRadians()

	val dlat = lat2 - lat1
	val dlon = lon2 - lon1

	val a = sin(dlat / 2).pow(2) + cos(lat1) * cos(lat2) * sin(dlon / 2).pow(2)
	val c = 2 * atan2(sqrt(a), sqrt(1 - a))

	return EARTH_RADIUS_METERS * c
}

private fun Double.toRadians() = this * PI / 180.0

val GeoJson.totalHeightDifference: Pair<Double, Double>
	get() {
		if (!isElevated) return 0.0 to 0.0

		return when (this) {
			is Point -> 0.0 to 0.0
			is LineString -> calculateHeightDifferencePair(coordinates)
			is MultiPoint -> calculateHeightDifferencePair(coordinates)
			is Polygon -> coordinates.fold(0.0 to 0.0) { acc, ring ->
				val (up, down) = calculateHeightDifferencePair(ring)
				acc.first + up to acc.second + down
			}

			is MultiLineString -> coordinates.fold(0.0 to 0.0) { acc, line ->
				val (up, down) = calculateHeightDifferencePair(line)
				acc.first + up to acc.second + down
			}

			is MultiPolygon -> coordinates.fold(0.0 to 0.0) { acc, poly ->
				val (up, down) = poly.fold(0.0 to 0.0) { accPoly, ring ->
					val (up, down) = calculateHeightDifferencePair(ring)
					accPoly.first + up to accPoly.second + down
				}
				acc.first + up to acc.second + down
			}

			is Feature -> geometry?.totalHeightDifference ?: 0.0 to 0.0
			is GeometryCollection -> geometries.fold(0.0 to 0.0) { acc, geom ->
				val (up, down) = geom.totalHeightDifference
				acc.first + up to acc.second + down
			}

			is FeatureCollection -> features.fold(0.0 to 0.0) { acc, feature ->
				val (up, down) = feature.totalHeightDifference
				acc.first + up to acc.second + down
			}
		}
	}

private fun calculateHeightDifferencePair(coords: List<GeoJsonCoordinates>): Pair<Double, Double> {
	if (coords.size < 2) return 0.0 to 0.0
	var totalUp = 0.0
	var totalDown = 0.0
	for (i in 0 until coords.size - 1) {
		val elevation1 = coords[i].getOrNull(2) ?: 0.0
		val elevation2 = coords[i + 1].getOrNull(2) ?: 0.0
		val difference = elevation2 - elevation1
		if (difference > 0) {
			totalUp += difference
		} else {
			totalDown += -difference
		}
	}
	return totalUp to totalDown
}

val GeoJson.farthestPointFromStart: GeoJsonCoordinates?
	get() {
		val startPoint = this.start ?: return null
		return getCoordinateDump().maxByOrNull { haversineDistance(startPoint, it) }
	}

fun Double.round(n: Int): Double {
	val factor = 10.0.pow(n)
	return round(this * factor) / factor
}