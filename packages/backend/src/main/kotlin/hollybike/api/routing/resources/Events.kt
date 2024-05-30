package hollybike.api.routing.resources

import io.ktor.resources.*

@Resource("/events")
class Events(val api: API = API()) {
	@Resource("future")
	class Future(val events: Events)

	@Resource("archived")
	class Archived(val events: Events)

	@Resource("images")
	class Images(val events: Events) {
		@Resource("me")
		class Me(val images: Images)

		@Resource("{imageId}")
		class ImageId(val images: Images, val imageId: Int)

		@Resource("meta-data")
		class MetaData(val images: Images)
	}

	@Resource("{id}")
	class Id(val events: Events = Events(), val id: Int) {
		@Resource("image")
		class UploadImage(val image: Id)

		@Resource("cancel")
		class Cancel(val cancel: Id)

		@Resource("schedule")
		class Schedule(val schedule: Id)

		@Resource("finish")
		class Finish(val finish: Id)

		@Resource("pend")
		class Pend(val pend: Id)

		@Resource("participations")
		class Participations(val eventId: Id) {
			@Resource("images-visibility")
			class ImagesVisibility(val participations: Participations)

			@Resource("{userId}")
			class User(val user: Participations, val userId: Int) {
				@Resource("promote")
				class Promote(val promote: User)

				@Resource("demote")
				class Demote(val demote: User)
			}
		}

		@Resource("images")
		class Images(val event: Id)
	}

	@Resource("meta-data")
	class MetaData(val events: Events)
}
