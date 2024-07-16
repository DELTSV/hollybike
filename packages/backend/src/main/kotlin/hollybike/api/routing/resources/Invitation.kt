/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.routing.resources

import io.ktor.resources.*

@Resource("/invitation")
class Invitation(val api: API = API()) {
	@Resource("{id}")
	class Id(val invitation: Invitation = Invitation(), val id: Int) {
		@Resource("disable")
		class Disable(val id: Id)

		@Resource("send-mail")
		class SendMail(val id: Id)
	}

	@Resource("meta-data")
	class MetaData(val invitation: Invitation = Invitation())
}