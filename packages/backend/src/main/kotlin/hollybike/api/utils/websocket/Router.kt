package hollybike.api.utils.websocket

import hollybike.api.repository.User
import hollybike.api.types.websocket.*
import io.ktor.http.*
import io.ktor.serialization.kotlinx.*
import io.ktor.server.application.*
import io.ktor.server.routing.*
import io.ktor.server.websocket.*
import io.ktor.websocket.*
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.channels.ClosedReceiveChannelException
import kotlinx.coroutines.launch
import kotlinx.serialization.json.Json
import org.jetbrains.exposed.sql.Database

class WebSocketCall(
	var parameters: Parameters,
	val path: String,
	val body: Body?,
	private val session: DefaultWebSocketServerSession,
	private val authVerifier: AuthVerifier
) {

	var user: User? = null

	constructor(message: Message, session: DefaultWebSocketServerSession, authVerifier: AuthVerifier) : this(
		Parameters.Empty,
		message.channel,
		message.data,
		session,
		authVerifier
	)

	suspend fun respond(data: Body) {
		session.sendSerialized(Message(data, path))
	}

	suspend fun respondText(data: String) {
		session.send(data)
	}

	suspend fun onSubscribe(call: suspend WebSocketCall.() -> Unit) {
		if(body is Subscribe) {
			user = authVerifier.verify(this.body.token)?.apply {
				call()
			} ?: run {
				respond(Subscribed(false))
				null
			}
		}
	}

	suspend fun onUnsubscribe(call: suspend WebSocketCall.() -> Unit = {}) {
		if(body is Unsubscribe) {
			user = null
			respond(Unsubscribed(false))
			call()
		}
	}
}

typealias RouteElement = MutableMap<PathElement, WebSocketRoute>

class WebSocketRouter(
	private val authVerifier: AuthVerifier
) {
	private val json = Json {
		ignoreUnknownKeys = true
	}

	private val routes: RouteElement = mutableMapOf()

	fun route(name: String, body: WebSocketRoute.() -> Unit) {
		val path = name.toPath()
		route(path, body)
	}

	fun request(name: String, body: suspend WebSocketCall.() -> Unit) {
		val path = name.toPath()
		route(path) {
			this.body = body
		}
	}

	internal fun request(key: PathElement, body: suspend WebSocketCall.() -> Unit) {
		(routes[key] ?: WebSocketRoute().also { routes[key] = it }).body = body
	}

	internal fun route(path: List<PathElement>, body: WebSocketRoute.() -> Unit) {
		val key = path.firstOrNull() ?: PathFragment("")
		val route = routes[key] ?: WebSocketRoute().also { routes[key] = it }
		if (path.size < 2) {
			route.body()
		} else {
			route.route(path.drop(1), body)
		}
	}

	suspend fun listen(wsServerSession: DefaultWebSocketServerSession) {
		wsServerSession.apply {
			try {
				for (frame in incoming) {
					val text = (frame as Frame.Text).readText()
					val message = json.decodeFromString<Message>(text)
					val path = message.channel.split("/").filter { it.isNotBlank() }.map { it.toPathElement() }
					val call = WebSocketCall(message, this, authVerifier)
					var handled = false
					routes.match(path.firstOrNull() ?: PathFragment("")).forEach { (_ , route) ->
						if(route?.execute(path.drop(1), call, this) == true) {
							handled = true
							return@forEach
						}
					}
					if(!handled) {
						println("Not found")
					}
				}
			} catch (e: ClosedReceiveChannelException) {
				println("Disconnect")
			} catch (e: Throwable) {
				e.printStackTrace()
				println("Error")
			}
		}
	}
}

class WebSocketRoute {
	private val routes: RouteElement = mutableMapOf()

	var body: (suspend WebSocketCall.() -> Unit)? = null

	fun route(name: String, body: WebSocketRoute.() -> Unit) {
		val path = name.toPath()
		route(path, body)
	}

	fun request(name: String, body: suspend WebSocketCall.() -> Unit) {
		val path = name.toPath()
		route(path) {
			this.body = body
		}
	}

	internal fun request(key: PathElement, body: suspend WebSocketCall.() -> Unit) {
		(routes[key] ?: WebSocketRoute().also { routes[key] = it }).body = body
	}

	internal fun route(path: List<PathElement>, body: WebSocketRoute.() -> Unit) {
		val key = path.firstOrNull() ?: PathFragment("")
		val route = routes[key] ?: WebSocketRoute().also { routes[key] = it }
		if (path.size < 2) {
			route.body()
		} else {
			route.route(path.drop(1), body)
		}
	}

	suspend fun execute(path: List<PathElement>, call: WebSocketCall, coroutineScope: CoroutineScope): Boolean {
		if (path.isEmpty()) {
			return body?.let {
				coroutineScope.launch {
					call.it()
				}
				true
			} ?: false
		} else {
			routes.match(path.first()).forEach { (key , route) ->
				val prevParam = call.parameters
				if(key is PathParam) {
					call.parameters = Parameters.build {
						this.appendAll(call.parameters)
						this.append(key.element, path.first().element)
					}
				}
				if(route?.execute(path.drop(1), call, coroutineScope) == true) {
					return true
				}
				call.parameters = prevParam
			}
			return false
		}
	}
}

private fun String.toPathElement(): PathElement {
	return if (startsWith("{") && endsWith("}")) {
		PathParam(this.trim('{', '}'))
	} else {
		PathFragment(this.trim())
	}
}

private fun String.toPath(): List<PathElement> = split("/").filter { it.isNotEmpty() }.map { it.toPathElement() }

private fun RouteElement.match(key: PathElement): List<Pair<PathElement, WebSocketRoute?>> =
	this.filter { it.key == key }.map { (k, v) -> k to v }

class WebSocketConfig {
	private lateinit var router: WebSocketRouter

	lateinit var authVerifier: AuthVerifier

	fun routing(body: WebSocketRouter.() -> Unit) {
		router = WebSocketRouter(authVerifier).apply(body)
	}

	suspend fun build(serverSession: DefaultWebSocketServerSession) {
		router.listen(serverSession)
	}
}

fun Application.webSocket(route: String, body: WebSocketConfig.() -> Unit) {
	install(WebSockets) {
		contentConverter = KotlinxWebsocketSerializationConverter(Json)
	}
	routing {
		webSocket(route) {
			WebSocketConfig().apply(body).build(this)
		}
	}
}