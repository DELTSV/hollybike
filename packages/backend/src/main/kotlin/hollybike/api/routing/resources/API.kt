package hollybike.api.routing.resources

import io.ktor.resources.*

@Resource("/api")
class API {
	@Resource("{path...}")
	class NotFound(val api: API = API(), val path: String)
}