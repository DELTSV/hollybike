package hollybike.api.types.shared

import kotlinx.serialization.Serializable

@Serializable
data class ImagePath(val path: String, val key: String)