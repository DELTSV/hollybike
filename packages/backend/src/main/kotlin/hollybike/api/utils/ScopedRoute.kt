/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.utils

import hollybike.api.plugins.user
import hollybike.api.types.user.EUserScope
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.resources.*
import io.ktor.server.response.*
import io.ktor.server.routing.Route
import io.ktor.util.pipeline.*

inline fun <reified R: Any> Route.get(scope: EUserScope, noinline body: suspend PipelineContext<Unit, ApplicationCall>.(R) -> Unit) {
	get<R> {
		if(call.user.scope.value < scope.value) {
			call.respond(HttpStatusCode.Forbidden, "You don't have sufficient permissions to access this resource")
		} else {
			this.body(it)
		}
	}
}

inline fun <reified R: Any> Route.post(scope: EUserScope, noinline body: suspend PipelineContext<Unit, ApplicationCall>.(R) -> Unit) {
	post<R> {
		if(call.user.scope.value < scope.value) {
			call.respond(HttpStatusCode.Forbidden, "You don't have sufficient permissions to access this resource")
		} else {
			this.body(it)
		}
	}
}

inline fun <reified R: Any> Route.patch(scope: EUserScope, noinline body: suspend PipelineContext<Unit, ApplicationCall>.(R) -> Unit) {
	patch<R> {
		if(call.user.scope.value < scope.value) {
			call.respond(HttpStatusCode.Forbidden, "You don't have sufficient permissions to access this resource")
		} else {
			this.body(it)
		}
	}
}

inline fun <reified R: Any> Route.put(scope: EUserScope, noinline body: suspend PipelineContext<Unit, ApplicationCall>.(R) -> Unit) {
	put<R> {
		if(call.user.scope.value < scope.value) {
			call.respond(HttpStatusCode.Forbidden, "You don't have sufficient permissions to access this resource")
		} else {
			this.body(it)
		}
	}
}

inline fun <reified R: Any> Route.delete(scope: EUserScope, noinline body: suspend PipelineContext<Unit, ApplicationCall>.(R) -> Unit) {
	delete<R> {
		if(call.user.scope.value < scope.value) {
			call.respond(HttpStatusCode.Forbidden, "You don't have sufficient permissions to access this resource")
		} else {
			this.body(it)
		}
	}
}