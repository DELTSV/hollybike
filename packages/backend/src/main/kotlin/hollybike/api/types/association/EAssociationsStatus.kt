package hollybike.api.types.association

enum class EAssociationsStatus(val value: Int) {
	Enabled(1),
	Disabled(-1);

	companion object {
		operator fun get(value: Int) = entries.first { it.value == value }
	}
}