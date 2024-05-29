package hollybike.api.types.event

enum class EEventParticipationStatus(val value: Int) {
	Joined(1),
	Left(2);

	companion object {
		operator fun get(value: Int) = EEventParticipationStatus.entries.first { it.value == value }
	}
}