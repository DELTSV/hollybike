package hollybike.api.types.event.participation

import hollybike.api.repository.UserJourney
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class TUserJourney(
	val id: Int,
	val file: String,
	@SerialName("avg_speed")
	val avgSpeed: Double? = null,
	@SerialName("total_elevation_loss")
	val totalElevationLoss: Double? = null,
	@SerialName("total_elevation_gain")
	val totalElevationGain: Double? = null,
	@SerialName("total_distance")
	val totalDistance: Double? = null,
	@SerialName("min_elevation")
	val minElevation: Double? = null,
	@SerialName("max_elevation")
	val maxElevation: Double? = null,
	@SerialName("total_time")
	val totalTime: Long? = null,
	@SerialName("max_speed")
	val maxSpeed: Double? = null
) {
	constructor(journey: UserJourney): this (
		journey.id.value,
		journey.journeySigned,
		journey.avgSpeed,
		journey.totalElevationLoss,
		journey.totalElevationGain,
		journey.totalDistance,
		journey.minElevation,
		journey.maxElevation,
		journey.totalTime,
		journey.maxSpeed
	)
}