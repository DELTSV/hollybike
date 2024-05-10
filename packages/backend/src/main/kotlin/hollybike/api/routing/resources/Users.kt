package hollybike.api.routing.resources

import io.ktor.resources.*

@Resource("/users")
class Users(val api: API = API()) {
	@Resource("me")
	class Me(val users: Users = Users()) {
		@Resource("profile-picture")
		class UploadProfilePicture(val me: Me = Me())
	}

	@Resource("{id}")
	class Id(val users: Users = Users(), val id: Int) {
		@Resource("profile-picture")
		class UploadProfilePicture(val id: Id)
	}

	@Resource("username/{username}")
	class Username(val users: Users = Users(), val username: String)

	@Resource("email/{email}")
	class Email(val users: Users = Users(), val email: String)

	@Resource("meta-data")
	class MetaData(val users: Users = Users())
}
