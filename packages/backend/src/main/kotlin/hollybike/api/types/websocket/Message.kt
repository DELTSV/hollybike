package hollybike.api.types.websocket

import kotlinx.serialization.ExperimentalSerializationApi
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JsonClassDiscriminator

@OptIn(ExperimentalSerializationApi::class)
@Serializable
@JsonClassDiscriminator("type")
sealed interface Body

@Serializable
@SerialName("error")
data class Error(
	val message: String
): Body

@Serializable
data class Message(
	val data: Body? = null,
	val channel: String
)