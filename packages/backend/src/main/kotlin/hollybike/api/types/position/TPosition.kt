package hollybike.api.types.position

import hollybike.api.repository.Position
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class TPosition(
	val latitude: Double,
	val longitude: Double,
	val altitude: Double? = null,
	@SerialName("place_name")
	val placeName: String? = null,
	@SerialName("place_type")
	val placeType: String,
	@SerialName("city_name")
	val cityName: String? = null,
	@SerialName("country_name")
	val countryName: String? = null,
	@SerialName("county_name")
	val countyName: String? = null,
	@SerialName("state_name")
	val stateName: String? = null,
) {
	constructor(entity: Position) : this(
		latitude = entity.latitude,
		longitude = entity.longitude,
		altitude = entity.altitude,
		placeName = entity.placeName,
		placeType = entity.placeType,
		cityName = entity.cityName,
		countryName = entity.countryName,
		countyName = entity.countyName,
		stateName = entity.stateName,
	)
}
