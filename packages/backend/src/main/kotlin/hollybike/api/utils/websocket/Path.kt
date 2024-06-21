package hollybike.api.utils.websocket

sealed interface PathElement {
	val element: String
}

data class PathFragment(private val fragment: String): PathElement {
	override val element: String
		get() = fragment
	override fun equals(other: Any?): Boolean = other is PathFragment && other.fragment == fragment || other is PathParam

	override fun hashCode(): Int = fragment.hashCode()
}

data class PathParam(private val key: String): PathElement {
	override val element: String
		get() = key
	override fun equals(other: Any?): Boolean = other is PathParam && other.key == key || other is PathFragment
	override fun hashCode(): Int = key.hashCode()
}