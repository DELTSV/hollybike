package hollybike.api.routing.resources

import io.ktor.resources.*

@Resource("/events")
class Events(val api: API = API()) {
	@Resource("{id}")
	class Id(val events: Events = Events(), val id: Int) {
		@Resource("participations")
		class Participations(val participations: Id) {
			@Resource("{userId}")
			class User(val user: Participations, val userId: Int) {
				@Resource("promote")
				class Promote(val promote: User)
			}
		}
	}
}
