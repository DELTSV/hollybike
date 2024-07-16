/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.stores

class EventStore {
	companion object {

		/**
		 * Total event count
		 */
		const val EVENT_COUNT = 11

		/**
		 * Event count for association 1
		 */
		const val ASSOCIATION_1_EVENT_COUNT = 6

		/**
		 * Event count visible for user 3
		 */
		const val USER_1_FUTURE_EVENT_COUNT = 4

		/**
		 * Event count visible for user 3
		 */
		const val USER_3_VISIBLE_EVENT_COUNT = 4

		/**
		 * Event count visible for user 4 (including own pending events)
		 */
		const val USER_4_VISIBLE_EVENT_COUNT = 5

		/**
		 * Event count that are archived in association 1
		 */
		const val ASSOCIATION_1_ARCHIVED_EVENT_COUNT = 2

		/**
		 * Event 1
		 * - Asso: Association 1
		 * - Status: PENDING
		 * - Participants: User 1 (Owner)
		 * - Scheduled: In 1 day and lasts 1 day
		 */
		val event1Asso1User1 = 1 to "Event 1 - Asso 1"

		/**
		 * Event 2
		 * - Asso: Association 1
		 * - Status: SCHEDULED
		 * - Participants: User 1 (Owner), User 2
		 * - Scheduled: Started 1 day ago and lasts 2 days
		 */
		val event2Asso1User1 = 2 to "Event 2 - Asso 1"

		/**
		 * Event 3
		 * - Asso: Association 1
		 * - Status: CANCELLED
		 * - Participants: User 1 (Owner)
		 * - Scheduled: In 1 day and lasts 1 day
		 */
		val event3Asso1User1 = 3 to "Event 3 - Asso 1"

		/**
		 * Event 4
		 * - Asso: Association 1
		 * - Status: TERMINATED
		 * - Participants: User 1 (Owner)
		 * - Scheduled: Lasted 1 day and ended 1 day ago
		 */
		val event4Asso1User1 = 4 to "Event 4 - Asso 1"

		/**
		 * Event 5
		 * - Asso: Association 1
		 * - Status: PENDING
		 * - Participants: User 2 (Owner)
		 * - Scheduled: Started one day ago and no end date
		 */
		val event5Asso1User2 = 5 to "Event 5 - Asso 1"

		/**
		 * Event 6
		 * - Asso: Association 1
		 * - Status: SCHEDULED
		 * - Participants: User 2 (Owner)
		 * - Scheduled: In 1 day and lasts 1 day
		 */
		val event6Asso1User2 = 6 to "Event 6 - Asso 1"

		/**
		 * Event 1
		 * - Asso: Association 2
		 * - Status: SCHEDULED
		 * - Participants: User 3 (Owner), User 4 (Organizer)
		 * - Scheduled: In 1 day and lasts 1 day
		 */
		val event1Asso2User3 = 7 to "Event 1 - Asso 2"

		/**
		 * Event 2
		 * - Asso: Association 2
		 * - Status: PENDING
		 * - Participants: User 4 (Owner)
		 * - Scheduled: In 1 day and lasts 1 day
		 */
		val event2Asso2User4 = 8 to "Event 2 - Asso 2"

		/**
		 * Event 3
		 * - Asso: Association 2
		 * - Status: SCHEDULED
		 * - Participants: User 4 (Owner)
		 * - Scheduled: In 1 day and lasts 1 day
		 */
		val event3Asso2User4 = 9 to "Event 3 - Asso 2"

		/**
		 * Event 4
		 * - Asso: Association 2
		 * - Status: SCHEDULED
		 * - Participants: User 4 (Owner), User 3, User 5
		 * - Scheduled: In 1 day and lasts 1 day
		 */
		val event4Asso2User4 = 10 to "Event 4 - Asso 2"

		/**
		 * Event 5
		 * - Asso: Association 2
		 * - Status: SCHEDULED
		 * - Participants: User 4 (Owner), User 3 (Organizer), User 5
		 * - Scheduled: In 1 day and lasts 1 day
		 */
		val event5Asso2User4 = 11 to "Event 5 - Asso 2"

		/**
		 * Unknown Event
		 */
		val unknown = 999 to "Unknown Event"
	}
}