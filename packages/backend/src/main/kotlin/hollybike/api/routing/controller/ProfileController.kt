package hollybike.api.routing.controller

import hollybike.api.plugins.user
import hollybike.api.repository.Users
import hollybike.api.repository.profileMapper
import hollybike.api.repository.userMapper
import hollybike.api.routing.resources.Profiles
import hollybike.api.services.ProfileService
import hollybike.api.types.lists.TLists
import hollybike.api.types.user.EUserStatus
import hollybike.api.types.user.TUserPartial
import hollybike.api.utils.search.Filter
import hollybike.api.utils.search.FilterMode
import hollybike.api.utils.search.getMapperData
import hollybike.api.utils.search.getSearchParam
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.resources.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import kotlin.math.ceil

class ProfileController(
	application: Application,
	private val profileService: ProfileService
) {
	init {
		application.routing {
			authenticate {
				getAllProfiles()
				getProfileById()
				getMetadata()
			}
		}
	}

	private fun Route.getProfileById() {
		get<Profiles.Id> { id ->
			profileService.getProfileById(call.user, id.id)?.let {
				call.respond(HttpStatusCode.OK, TUserPartial(it))
			} ?: run {
				call.respond(HttpStatusCode.NotFound)
			}
		}
	}

	private fun Route.getAllProfiles() {
		get<Profiles> {
			val param = call.request.queryParameters.getSearchParam(profileMapper).apply {
				filter.add(Filter(Users.status, EUserStatus.Disabled.value.toString(), FilterMode.NOT_EQUAL))
			}
			val count = profileService.getAllProfileCount(call.user, param)
			val list = profileService.getAllProfile(call.user, param)
			call.respond(HttpStatusCode.OK, TLists(
				list.map { TUserPartial(it) },
				param.page,
				ceil(count.toDouble() / param.perPage).toInt(),
				param.perPage,
				count.toInt()
			))
		}
	}

	private fun Route.getMetadata() {
		get<Profiles.MetaData> {
			call.respond(profileMapper.getMapperData())
		}
	}
}