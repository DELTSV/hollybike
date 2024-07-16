/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.types.event

import hollybike.api.repository.Event
import kotlinx.datetime.Clock
import kotlin.time.Duration.Companion.hours

enum class EEventStatus(val value: Int) {
	Pending(1),
	Scheduled(2),
	Cancelled(3),
	Finished(4),
	Now(5);

	companion object {
		operator fun get(value: Int) = EEventStatus.entries.first { it.value == value }

		fun fromEvent(event: Event): EEventStatus {
			val now = Clock.System.now()

			if (event.startDateTime > now) {
				return event.status
			}

			if (event.endDateTime != null && event.endDateTime!! > now) {
				return if (event.status == Scheduled) {
					Now
				} else {
					event.status
				}
			}

			if (event.endDateTime == null) {
				val endDateTime = event.startDateTime + 4.hours
				if (endDateTime > now) {
					return if (event.status == Scheduled) {
						Now
					} else {
						event.status
					}
				}
			}

			return Finished
		}
	}
}