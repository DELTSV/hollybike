package hollybike.api.routing.resources

import io.ktor.resources.*

@Resource("/journeys")
class Journeys(val api: API = API()) {
	@Resource("/meta-data")
	class MetaData(val journeys: Journeys = Journeys())

	@Resource("/{id}")
	class Id(val journeys: Journeys = Journeys(), val id: Int) {
		@Resource("/file")
		class File(val id: Id)

		@Resource("/positions")
		class Positions(val id: Id)
	}
}