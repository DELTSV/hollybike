package hollybike.api.routing.resources

import io.ktor.resources.*

@Resource("/notifications")
class Notifications(val api: API = API()) {
	@Resource("meta-data")
	class MetaData(val notifications: Notifications = Notifications())

	@Resource("{id}")
	class Id(val notifications: Notifications = Notifications(), val id: Int) {
		@Resource("seen")
		class Seen(val id: Id)
	}

	@Resource("seen")
	class Seen(val notifications: Notifications = Notifications())
}