/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.utils

import io.ktor.server.application.*

data class ListParams(
	val page: Int = 0,
	val perPage: Int = 20
)

val ApplicationCall.listParams: ListParams get() = ListParams(
	request.queryParameters["page"]?.toIntOrNull() ?: 0,
	request.queryParameters["per_page"]?.toIntOrNull() ?: 20
)