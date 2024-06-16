 package hollybike.api.types.journey

import kotlinx.serialization.json.JsonArray
import kotlinx.serialization.json.JsonElement
import kotlinx.serialization.json.JsonObject
import kotlinx.serialization.json.JsonPrimitive

fun Gpx.toGeoJson(): GeoJson {
	val tracks = trk.mapNotNull { track ->
		track.getTrack()
	}

	val routes = rte.mapNotNull { route ->
		route.getRoute()
	}

	val waypoints = wpt.map { waypoint ->
		waypoint.getPoint()
	}

	return FeatureCollection(
		tracks + routes + waypoints
	)
}

private fun Trk.getTrack(): Feature? {
	val times = mutableListOf<JsonElement>()
	val track = trkSeg.map { segment ->
		segment.trkPt.map { trkpt ->
			trkpt.time?.let { t -> times.add(JsonPrimitive(t.toString())) }
			listOfNotNull(
				trkpt.lon,
				trkpt.lat,
				trkpt.ele
			)
		}
	}
	if(track.isEmpty()) {
		return null
	}
	val properties = mutableMapOf<String, JsonElement>()
	name?.let { properties["name"] = JsonPrimitive(it) }
	cmt?.let { properties["cmt"] = JsonPrimitive(it) }
	desc?.let { properties["desc"] = JsonPrimitive(it) }
	if(times.isNotEmpty()) {
		properties["coordTimes"] = JsonArray(times)
	}
	return Feature(
		geometry = if(track.size == 1) {
			LineString(track.first())
		} else {
			MultiLineString(track)
		},
		properties = JsonObject(properties)
	)
}

private fun Rte.getRoute(): Feature? {
	val times = mutableListOf<JsonElement>()
	val line = rtePt.map { pt ->
		pt.time?.let { times.add(JsonPrimitive(it.toString())) }
		listOfNotNull(
			pt.lon,
			pt.lat,
			pt.ele
		)
	}
	if(line.isEmpty()) {
		return null
	}
	val properties = mutableMapOf<String, JsonElement>()
	name?.let { properties["name"] = JsonPrimitive(it) }
	cmt?.let { properties["cmt"] = JsonPrimitive(it) }
	desc?.let { properties["desc"] = JsonPrimitive(it) }
	type?.let { properties["type"] = JsonPrimitive(it) }
	return Feature(
		properties = JsonObject(properties),
		geometry = LineString(line)
	)
}

private fun Wpt.getPoint(): Feature {
	val point = listOfNotNull(
		lon,
		lat,
		ele
	)
	val properties = mutableMapOf<String, JsonElement>()
	name?.let { properties["name"] = JsonPrimitive(it) }
	cmt?.let { properties["cmt"] = JsonPrimitive(it) }
	desc?.let { properties["desc"] = JsonPrimitive(it) }
	type?.let { properties["type"] = JsonPrimitive(it) }
	time?.let { properties["time"] = JsonPrimitive(it.toString()) }
	sym?.let { properties["sym"] = JsonPrimitive(it) }
	return Feature(
		properties = JsonObject(properties),
		geometry = Point(
			point
		)
	)
}