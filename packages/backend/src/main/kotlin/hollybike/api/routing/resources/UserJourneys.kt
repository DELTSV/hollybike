/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.routing.resources

import io.ktor.resources.*

@Resource("/user-journeys")
class UserJourneys(val api: API = API()) {
	@Resource("/meta-data")
	class MetaData(val userJourneys: UserJourneys = UserJourneys())

	@Resource("/{id}")
	class Id(val userJourneys: UserJourneys = UserJourneys(), val id: Int) {
		@Resource("/file")
		class File(val file: Id)
	}

	@Resource("/user/{id}")
	class User(val userJourneys: UserJourneys = UserJourneys(), val id: Int)
}