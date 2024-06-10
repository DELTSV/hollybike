package hollybike.api.types.event.image

import kotlinx.datetime.Instant
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class TImageMetadata(
	@SerialName("taken_date_time")
	val takenDateTime: Instant,
	val position: TImagePositionMetadata?,
)
