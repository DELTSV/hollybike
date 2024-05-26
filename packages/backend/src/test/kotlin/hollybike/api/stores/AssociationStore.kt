package hollybike.api.stores

class AssociationStore {
	companion object {

		/**
		 * Root association, contains only the root user.
		 */
		val root = 1 to "Root Association"

		/**
		 * Regular association, contains multiple users.
		 */
		val association1 = 2 to "Association 1"

		/**
		 * Regular association, contains multiple users.
		 */
		val association2 = 3 to "Association 2"

		/**
		 * Disabled association, contains multiple users.
		 */
		val disabled = 4 to "Disabled Association"

		/**
		 * Unknown association.
		 */
		val unknown = 999 to "Unknown Association"

		/**
		 * New association.
		 */
		val new = 1000 to "New Association"
	}
}