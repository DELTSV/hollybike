package hollybike.api.routing.resources

import io.ktor.resources.*

@Resource("/associations")
class Associations<T>(val parent: T) {
	@Resource("{id}")
	class Id<T>(val associations: Associations<T>, val id: Int) {
		@Resource("picture")
		class Picture<T>(val id: Id<T>)
	}

	@Resource("me")
	class Me<T>(val associations: Associations<T>) {
		@Resource("picture")
		class Picture<T>(val me: Me<T>)
	}
}