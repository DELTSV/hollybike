/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.types.invitation

import kotlinx.serialization.Serializable

@Serializable
enum class EInvitationStatus(val value: Int) {
	Enabled(1),
	Disabled(-1);

	companion object {
		operator fun get(value: Int) = EInvitationStatus.entries.first { it.value == value }
	}
}