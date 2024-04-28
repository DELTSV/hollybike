package hollybike.api.routing.resources

import io.ktor.resources.*

@Resource("/events")
class Events(val api: API = API()) {
	@Resource("{id}")
	class Id(val events: Events = Events(), val id: Int)
}
