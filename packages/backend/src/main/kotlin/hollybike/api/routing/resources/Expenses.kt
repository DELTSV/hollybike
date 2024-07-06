package hollybike.api.routing.resources

import io.ktor.resources.*

@Resource("/expenses")
class Expenses(val api: API) {
	@Resource("/{id}")
	class Id(val expenses: Expenses, val id: Int)

	@Resource("/meta-data")
	class Metadata(val expenses: Expenses)
}