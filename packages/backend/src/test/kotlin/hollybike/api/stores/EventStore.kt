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
		const val USER_3_VISIBLE_EVENT_COUNT = 4

		/**
		 * Event count visible for user 4 (including own pending events)
		 */
		const val USER_4_VISIBLE_EVENT_COUNT = 5

		/**
		 * Event 1
		 * - Asso: Association 1
		 * - Status: PENDING
		 * - Participants: User 1 (Owner)
		 */
		val event1Asso1User1 = 1 to "Event 1 - Asso 1"

		/**
		 * Event 2
		 * - Asso: Association 1
		 * - Status: SCHEDULED
		 * - Participants: User 1 (Owner), User 2
		 */
		val event2Asso1User1 = 2 to "Event 2 - Asso 1"

		/**
		 * Event 3
		 * - Asso: Association 1
		 * - Status: CANCELLED
		 * - Participants: User 1 (Owner)
		 */
		val event3Asso1User1 = 3 to "Event 3 - Asso 1"

		/**
		 * Event 4
		 * - Asso: Association 1
		 * - Status: TERMINATED
		 * - Participants: User 1 (Owner)
		 */
		val event4Asso1User1 = 4 to "Event 4 - Asso 1"

		/**
		 * Event 5
		 * - Asso: Association 1
		 * - Status: PENDING
		 * - Participants: User 2 (Owner)
		 */
		val event5Asso1User2 = 5 to "Event 5 - Asso 1"

		/**
		 * Event 6
		 * - Asso: Association 1
		 * - Status: SCHEDULED
		 * - Participants: User 2 (Owner)
		 */
		val event6Asso1User2 = 6 to "Event 6 - Asso 1"

		/**
		 * Event 1
		 * - Asso: Association 2
		 * - Status: SCHEDULED
		 * - Participants: User 3 (Owner), User 4 (Organizer)
		 */
		val event1Asso2User3 = 7 to "Event 1 - Asso 2"

		/**
		 * Event 2
		 * - Asso: Association 2
		 * - Status: PENDING
		 * - Participants: User 4 (Owner)
		 */
		val event2Asso2User4 = 8 to "Event 2 - Asso 2"

		/**
		 * Event 3
		 * - Asso: Association 2
		 * - Status: SCHEDULED
		 * - Participants: User 4 (Owner)
		 */
		val event3Asso2User4 = 9 to "Event 3 - Asso 2"

		/**
		 * Event 4
		 * - Asso: Association 2
		 * - Status: SCHEDULED
		 * - Participants: User 4 (Owner), User 3, User 5
		 */
		val event4Asso2User4 = 10 to "Event 4 - Asso 2"

		/**
		 * Event 5
		 * - Asso: Association 2
		 * - Status: SCHEDULED
		 * - Participants: User 4 (Owner), User 3 (Organizer), User 5
		 */
		val event5Asso2User4 = 11 to "Event 5 - Asso 2"

		/**
		 * Unknown Event
		 */
		val unknown = 999 to "Unknown Event"
	}
}