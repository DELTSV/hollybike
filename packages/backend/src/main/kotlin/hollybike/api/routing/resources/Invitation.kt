package hollybike.api.routing.resources

import io.ktor.resources.*

@Resource("/invitation")
class Invitation(val api: API = API()) {
	@Resource("{id}")
	class Id(val invitation: Invitation = Invitation(), val id: Int) {
		@Resource("disable")
		class Disable(val id: Id)
	}
}