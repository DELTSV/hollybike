package hollybike.api.routing.resources

import io.ktor.resources.*

@Resource("/users")
class Users(val api: API = API()) {
	@Resource("me")
	class Me(val users: Users = Users())

	@Resource("{id}")
	class Id(val users: Users = Users(), val id: Int)

	@Resource("username/{username}")
	class Username(val users: Users = Users(), val username: String)

	@Resource("email/{email}")
	class Email(val users: Users = Users(), val email: String)

	@Resource("profile-picture")
	class UploadProfilePicture(val users: Users = Users())
}
