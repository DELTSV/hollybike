package hollybike.api.routing.resources

import io.ktor.resources.*

@Resource("/api")
class API {
	@Resource("{path...}")
	class NotFound(val api: API = API(), val path: List<String>)

	@Resource("smtp")
	class SMTP(val api: API = API())
}