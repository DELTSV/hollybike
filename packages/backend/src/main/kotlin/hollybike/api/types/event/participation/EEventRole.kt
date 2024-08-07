/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.types.event.participation

enum class EEventRole(val value: Int) {
	Member(1),
	Organizer(2);

	companion object {
		operator fun get(value: Int) = EEventRole.entries.first { it.value == value }
	}
}