package hollybike.api.routing.resources

import io.ktor.resources.*

@Resource("/auth")
class Auth(val api: API = API()) {
	@Resource("login")
	class Login(val auth: Auth = Auth())

	@Resource("/signin")
	class Signup(val auth: Auth = Auth())

	@Resource("/refresh")
	class Refresh(val auth: Auth = Auth())
}