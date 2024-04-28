package hollybike.api.types.event

enum class EEventStatus(val value: Int) {
	PENDING(1),
	SCHEDULED(2),
	CANCELLED(3),
	FINISHED(4);

	companion object {
		operator fun get(value: Int) = EEventStatus.entries.first { it.value == value }
	}
}