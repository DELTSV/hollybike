/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.stores

class UserStore {
	companion object {
		/**
		 * Total user count
		 */
		const val USER_COUNT = 13

		/**
		 * User count for association 1
		 */
		const val USER_COUNT_ASSOCIATION_1 = 4

		/**
		 * Root user, part of the root association.
		 */
		val root = 1 to "root@hollybike.fr"

		/**
		 * Regular user, part of the association 1.
		 */
		val user1 = 2 to "user1@hollybike.fr"

		/**
		 * Regular user, part of the association 1.
		 */
		val user2 = 3 to "user2@hollybike.fr"

		/**
		 * Regular user, part of the association 2.
		 */
		val user3 = 4 to "user3@hollybike.fr"

		/**
		 * Regular user, part of the association 2.
		 */
		val user4 = 5 to "user4@hollybike.fr"

		/**
		 * Regular user, part of the association 2.
		 */
		val user5 = 6 to "user5@hollybike.fr"

		/**
		 * Regular user, part of the disabled association.
		 */
		val user6 = 7 to "user6@hollybike.fr"

		/**
		 * Disabled user, part of the association 1.
		 */
		val disabled1 = 8 to "disabled1@hollybike.fr"

		/**
		 * Disabled user, part of the association 2.
		 */
		val disabled2 = 9 to "disabled2@hollybike.fr"

		/**
		 * Disabled user, part of the disabled association.
		 */
		val disabled3 = 10 to "disabled3@hollybike.fr"

		/**
		 * Admin user, part of the association 1.
		 */
		val admin1 = 11 to "admin1@hollybike.fr"

		/**
		 * Admin user, part of the association 2.
		 */
		val admin2 = 12 to "admin2@hollybike.fr"

		/**
		 * Admin user, part of the disabled association.
		 */
		val admin3 = 13 to "admin3@hollybike.fr"

		/**
		 * Unknown user.
		 */
		val unknown = 999 to "unknown@hollybike.fr"

		/**
		 * New user.
		 */
		val new = 1000 to "new_account@hollybike.fr"
	}
}