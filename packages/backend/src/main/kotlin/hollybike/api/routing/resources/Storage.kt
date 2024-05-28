package hollybike.api.routing.resources

import io.ktor.resources.*

@Resource("/storage")
class Storage {
	@Resource("object")
	class Object(val storage: Storage = Storage())
}