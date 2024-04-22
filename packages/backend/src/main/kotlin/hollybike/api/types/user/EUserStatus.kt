package hollybike.api.types.user

import kotlinx.serialization.Serializable

@Serializable
enum class EUserStatus(val value: Int) {
	Enabled(1),
	Disabled(-1);

	companion object {
		operator fun get(value: Int) = entries.first { it.value == value }
	}
}