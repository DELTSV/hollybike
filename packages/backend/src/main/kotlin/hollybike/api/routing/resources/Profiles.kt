/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.routing.resources

import io.ktor.resources.*

@Resource("/profiles")
class Profiles(val api: API = API()) {
	@Resource("{id}")
	class Id(val profiles: Profiles = Profiles(), val id: Int)

	@Resource("meta-data")
	class MetaData(val profiles: Profiles = Profiles())
}