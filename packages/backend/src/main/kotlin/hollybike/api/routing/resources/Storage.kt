package hollybike.api.routing.resources

import io.ktor.resources.*

@Resource("/storage")
class Storage {
	@Resource("{path...}")
	class Data(val storage: Storage = Storage(), val path: Array<String>)
}