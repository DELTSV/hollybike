package hollybike.api.types.user

import kotlinx.serialization.Serializable

@Serializable
enum class EUserScope(val value: Int) {
	User(1),
	Admin(2),
	Root(3);

	companion object {
		operator fun get(value: Int) = entries.first { it.value == value }
	}

	infix fun atLeast(other: EUserScope?): Boolean = this.value >= (other?.value ?: 0)

	infix fun not(other: EUserScope): Boolean = this.value < other.value
}