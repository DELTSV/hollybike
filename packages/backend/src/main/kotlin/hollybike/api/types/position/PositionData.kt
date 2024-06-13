package hollybike.api.types.position

data class PositionData(
	val latitude: Double,
	val longitude: Double,
	val altitude: Double? = null,
	val placeName: String? = null,
	val placeType: String,
	val cityName: String? = null,
	val countryName: String? = null,
	val countyName: String? = null,
	val stateName: String? = null,
)
