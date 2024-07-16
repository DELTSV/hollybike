/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.routing.resources

import io.ktor.resources.*

@Resource("/api")
class API {
	@Resource("{path...}")
	class NotFound(val api: API = API(), val path: List<String>)

	@Resource("smtp")
	class SMTP(val api: API = API())

	@Resource("conf-done")
	class ConfDone(val api: API = API())

	@Resource("restart")
	class Restart(val api: API = API())

	@Resource("on-premise")
	class OnPremise(val api: API = API())
}