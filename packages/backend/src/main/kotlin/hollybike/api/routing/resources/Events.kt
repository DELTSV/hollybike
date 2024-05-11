package hollybike.api.routing.resources

import io.ktor.resources.*

@Resource("/events")
class Events(val api: API = API()) {
	@Resource("{id}")
	class Id(val events: Events = Events(), val id: Int) {
		@Resource("image")
		class UploadImage(val image: Id)

		@Resource("cancel")
		class Cancel(val cancel: Id)

		@Resource("schedule")
		class Schedule(val schedule: Id)

		@Resource("finish")
		class Finish(val finish: Id)

		@Resource("pend")
		class Pend(val pend: Id)

		@Resource("participations")
		class Participations(val participations: Id) {
			@Resource("{userId}")
			class User(val user: Participations, val userId: Int) {
				@Resource("promote")
				class Promote(val promote: User)

				@Resource("demote")
				class Demote(val demote: User)
			}
		}
	}
}
