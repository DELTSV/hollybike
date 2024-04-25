package hollybike.api.routing.controller

import hollybike.api.plugins.user
import hollybike.api.routing.resources.Users
import hollybike.api.services.UserService
import hollybike.api.types.user.TUser
import io.ktor.http.*
import io.ktor.http.content.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.request.*
import io.ktor.server.resources.*
import io.ktor.server.resources.post
import io.ktor.server.response.*
import io.ktor.server.routing.*

class UserController(
    application: Application,
    private val userService: UserService,
) {
    init {
        application.routing {
            authenticate {
                getMe()
                getUserById()
                uploadImages()
            }
        }
    }

    private fun Route.getMe() {
        get<Users.Me> {
            call.respond(TUser(call.user))
        }
    }

    private fun Route.getUserById() {
        get<Users.Id> {
            userService.getUser(call.user, it.id)?.let { user ->
                call.respond(TUser(user))
            } ?: run {
                call.respond(HttpStatusCode.NotFound, "User not found")
            }
        }
    }

    private fun Route.uploadImages() {
        post<Users.UploadTest> {
            val form = call.receiveMultipart()
            form.forEachPart {
                when (it) {
                    is PartData.FileItem -> {
                        println(it.name)
                        println(it.originalFileName)
                        println(it.streamProvider().readBytes().size)
                    }

                    is PartData.BinaryChannelItem -> TODO()
                    is PartData.BinaryItem -> TODO()
                    is PartData.FormItem -> TODO()
                }
            }

            call.respond(HttpStatusCode.OK)
        }
    }
}
