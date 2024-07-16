/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.routing.resources

import io.ktor.resources.*

@Resource("/expenses")
class Expenses(val api: API) {
	@Resource("/{id}")
	class Id(val expenses: Expenses, val id: Int) {
		@Resource("/proof")
		class Proof(val id: Id)
	}

	@Resource("/meta-data")
	class Metadata(val expenses: Expenses)
}