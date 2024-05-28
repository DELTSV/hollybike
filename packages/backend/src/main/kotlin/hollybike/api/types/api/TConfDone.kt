package hollybike.api.types.api

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class TConfDone(
	@SerialName("conf_done")
	val confDone: Boolean,
)
