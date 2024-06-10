package hollybike.api.types.journey

import kotlinx.datetime.Instant
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import nl.adaptivity.xmlutil.serialization.XmlElement
import nl.adaptivity.xmlutil.serialization.XmlSerialName

@XmlSerialName("gpx", "http://www.topografix.com/GPX/1/1")
@Serializable
data class Gpx(
	val version: String,
	val creator: String,
	val wpt: List<Wpt>,
	val rte: List<Rte>,
	val trk: List<Trk>
)

@XmlElement(true)
@XmlSerialName("bounds")
@Serializable
data class Bounds(
	@SerialName("minlat")
	val minLat: Double,
	@SerialName("minlon")
	val minLon: Double,
	@SerialName("maxlat")
	val maxLat: Double,
	@SerialName("maxlon")
	val maxLon: Double
)

@XmlElement(true)
@XmlSerialName("wpt")
@Serializable
data class Wpt(
	val lon: Double,
	val lat: Double,
	@XmlElement(true)
	val ele: Double? = null,
	@XmlElement(true)
	val time: Instant? = null,
	@XmlElement(true)
	@SerialName("magvar")
	val magVar: Double? = null,
	@XmlElement(true)
	@SerialName("geoddheight")
	val geoIdHeight: Double? = null,
	@XmlElement(true)
	val name: String? = null,
	@XmlElement(true)
	val cmt: String? = null,
	@XmlElement(true)
	val desc: String? = null,
	@XmlElement(true)
	val src: String? = null,
	@XmlElement(true)
	val link: Link? = null,
	@XmlElement(true)
	val sym: String? = null,
	@XmlElement(true)
	val type: String? = null,
	@XmlElement(true)
	val fix: FixType? = null,
	@XmlElement(true)
	val sat: Int? = null,
	@XmlElement(true)
	@SerialName("hdop")
	val hDop: Double? = null,
	@XmlElement(true)
	@SerialName("vdop")
	val vDop: Double? = null,
	@XmlElement(true)
	@SerialName("pdop")
	val pDop: Double? = null,
	@XmlElement(true)
	@SerialName("ageofdgpsdata")
	val ageOfDGpsData: Double? = null,
	@XmlElement(true)
	@SerialName("dgpsid")
	val dGpsId: UShort? = null
)

@Serializable
enum class FixType {
	@SerialName("none")
	None,
	@SerialName("2d")
	`2D`,
	@SerialName("3d")
	`3D`,
	@SerialName("dgps")
	DGps,
	@SerialName("pps")
	PPS
}

@XmlSerialName("rte")
@Serializable
data class Rte(
	@XmlElement(true)
	val name: String? = null,
	@XmlElement(true)
	val cmt: String? = null,
	@XmlElement(true)
	val desc: String? = null,
	@XmlElement(true)
	val src: String? = null,
	@XmlElement(true)
	val link: Link? = null,
	@XmlElement(true)
	val number: UInt? = null,
	@XmlElement(true)
	val type: String? = null,
	@XmlSerialName("rtept")
	@XmlElement(true)
	val rtePt: List<Wpt>
)

@XmlSerialName("trk")
@Serializable
data class Trk(
	@XmlElement(true)
	val name: String? = null,
	@XmlElement(true)
	val cmt: String? = null,
	@XmlElement(true)
	val desc: String? = null,
	@XmlElement(true)
	val src: String? = null,
	@XmlElement(true)
	val link: Link? = null,
	@XmlElement(true)
	val number: UInt? = null,
	@XmlElement(true)
	val type: String? = null,
	@SerialName("trkseg")
	@XmlElement(true)
	val trkSeg: List<TrkSeg>
)

@XmlSerialName("trkseg")
@Serializable
data class TrkSeg(
	@XmlSerialName("trkpt")
	val trkPt: List<Wpt>
)

@Serializable
data class Link(
	val href: String,
	@XmlElement(true) val text: String? = null,
	@XmlElement(true) val type: String? = null
)