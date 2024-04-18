package hollybike.api.routing.resources

import io.ktor.resources.*

@Resource("login")
class Login(val api: API = API())

@Resource("/logout")
class Logout(val api: API = API())

@Resource("/signin")
class Signin(val api: API = API())