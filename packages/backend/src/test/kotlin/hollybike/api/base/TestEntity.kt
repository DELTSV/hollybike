package hollybike.api.base

val Pair<Int, String>.id: Int get() = first
val Pair<Int, String>.value: String get() = second