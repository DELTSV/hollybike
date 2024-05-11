package hollybike.api.types.event

enum class EEventRole(val value: Int) {
	MEMBER(1),
	ORGANIZER(2);

	companion object {
		operator fun get(value: Int) = EEventRole.entries.first { it.value == value }
	}
}