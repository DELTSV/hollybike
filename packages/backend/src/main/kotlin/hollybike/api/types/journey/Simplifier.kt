/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.types.journey

import hollybike.api.json
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.JsonElement
import kotlinx.serialization.json.JsonObject
import java.net.URLEncoder
import kotlin.math.abs
import kotlin.math.min


fun triangleArea(p1: Pair<Double, Double>, p2: Pair<Double, Double>, p3: Pair<Double, Double>): Double {
	return abs(p1.first * (p2.second - p3.second) + p2.first * (p3.second - p1.second) + p3.first * (p1.second - p2.second)) / 2.0
}

fun triangleAreasFromArray(arr: List<Pair<Double, Double>>): DoubleArray {
	val n = arr.size
	val result = DoubleArray(n) { Double.POSITIVE_INFINITY }

	for (i in 1 until n - 1) {
		result[i] = triangleArea(arr[i - 1], arr[i], arr[i + 1])
	}

	return result
}

fun remove(array: DoubleArray, index: Int) {
	for (i in index until array.size - 1) {
		array[i] = array[i + 1]
	}
}

class Simplifier(pts: List<Pair<Double, Double>>) {
	private val ptsIn = pts.toList()
	private val pts = pts.map { Pair(it.first, it.second) }.toList()
	private val thresholds = buildThresholds()
	private val orderedThresholds = thresholds.sortedDescending()

	private fun buildThresholds(): DoubleArray {
		val nmax = pts.size
		val realAreas = triangleAreasFromArray(pts)
		val realIndices = (0 until nmax).toMutableList()

		val areas = realAreas.copyOf()
		val i = realIndices.toMutableList()

		var minVert = areas.withIndex().minByOrNull { it.value }!!.index
		var thisArea = areas[minVert]
		remove(areas, minVert)
		i.removeAt(minVert)

		while (thisArea < Double.POSITIVE_INFINITY) {
			var skip: Int? = null

			if (minVert < i.size && minVert > 0 && minVert < i.size - 1) {
				val rightArea = triangleArea(pts[i[minVert - 1]], pts[i[minVert]], pts[i[minVert + 1]])
				if (rightArea <= thisArea) {
					thisArea = rightArea
					skip = minVert
				}
				realAreas[i[minVert]] = rightArea
				areas[minVert] = rightArea
			}

			if (minVert > 1) {
				val leftArea = triangleArea(pts[i[minVert - 2]], pts[i[minVert - 1]], pts[i[minVert]])
				if (leftArea <= thisArea) {
					thisArea = leftArea
					skip = minVert - 1
				}
				realAreas[i[minVert - 1]] = leftArea
				areas[minVert - 1] = leftArea
			}

			minVert = skip ?: areas.withIndex().minByOrNull { it.value }!!.index
			i.removeAt(minVert)
			thisArea = areas[minVert]
			remove(areas, minVert)
		}

		return realAreas
	}

	fun simplify(number: Int? = null, ratio: Double? = null, threshold: Double? = null): List<Pair<Double, Double>> {
		return when {
			threshold != null -> byThreshold(threshold)
			number != null -> byNumber(number)
			else -> byRatio(ratio ?: 0.90)
		}
	}

	private fun byThreshold(threshold: Double): List<Pair<Double, Double>> {
		return ptsIn.filterIndexed { index, _ -> thresholds[index] >= threshold }
	}

	private fun byNumber(n: Int): List<Pair<Double, Double>> {
		val threshold = orderedThresholds[min(n, orderedThresholds.size - 1)]
		return byThreshold(threshold).take(n)
	}

	private fun byRatio(ratio: Double): List<Pair<Double, Double>> {
		require(ratio in 0.0..1.0) { "Ratio must be 0 < r <= 1" }
		return byNumber((ratio * thresholds.size).toInt())
	}
}

@Suppress("UNCHECKED_CAST")
private fun simplifyCoordinates(coordinates: List<GeoJsonCoordinates>, number: Int, closed: Boolean = false): List<GeoJsonCoordinates> {
	val simplifier = Simplifier(coordinates.map { it[0] to it[1] })
	val simplified = simplifier.simplify(number = number).map { listOf(it.first, it.second) }
	return if (closed) {
		simplified.dropLast(1) + simplified.first() as List<GeoJsonCoordinates>
	} else {
		simplified
	}
}

fun GeoJson.simplify(number: Int): GeoJson {
	return when (this) {
		is Point, is MultiPoint -> this
		is LineString -> this.copy(coordinates = simplifyCoordinates(this.coordinates, number))
		is MultiLineString -> this.copy(coordinates = this.coordinates.map { simplifyCoordinates(it, number) })
		is Polygon -> this.copy(coordinates = this.coordinates.map { simplifyCoordinates(it, number, closed = true) })
		is MultiPolygon -> this.copy(coordinates = this.coordinates.map { it.map { ring -> simplifyCoordinates(ring, number, closed = true) } })
		is GeometryCollection -> this.copy(geometries = this.geometries.map { it.simplify(number) as GeometryShape })
		is Feature -> this.copy(geometry = this.geometry?.let { it.simplify(number) as GeometryShape })
		is FeatureCollection -> this.copy(features = this.features.map { it.simplify(number) })
	}
}

fun GeoJson.updateGeoJsonProperties(key: String, value: JsonElement): GeoJson {
	return when (this) {
		is Feature -> {
			val updatedProperties = this.properties?.toMutableMap() ?: mutableMapOf()
			updatedProperties[key] = value
			this.copy(properties = JsonObject(updatedProperties))
		}
		is FeatureCollection -> {
			this.copy(features = this.features.map { it.updateGeoJsonProperties(key, value) })
		}
		is GeometryCollection -> {
			this.copy(geometries = this.geometries.map { it.updateGeoJsonProperties(key, value) as GeometryShape })
		}
		else -> this
	}
}

fun GeoJson.simplifyToUrlSafe(maxCharCount: Int = 7000): GeoJson {
	val maxCoordinatesLen = 25
	val maxCoordinates = maxCharCount / maxCoordinatesLen

	return this.simplify(maxCoordinates)
}

fun GeoJson.toJson(): String {
	return json.encodeToString(this)
}

fun GeoJson.encodeUrl(): String {
	return URLEncoder.encode(toJson(), "UTF-8")
}

fun GeoJson.clean(): GeoJson {
	return when (this) {
		is Feature -> this.copy(properties = JsonObject(emptyMap()))
		is FeatureCollection -> this.copy(features = this.features.map { it.clean() })
		is GeometryCollection -> this.copy(geometries = this.geometries.map { it.clean() as GeometryShape })
		else -> this
	}
}