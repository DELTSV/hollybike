package hollybike.api.base

val Pair<Int, String>.id: Int get() = first
val Pair<Int, String>.value: String get() = second

fun countWithCap(cap: Int, count: Int): Int {
	return if (count > cap) cap else count
}

fun nbPages(nbItems: Int, pageSize: Int): Int {
	return (nbItems + pageSize - 1) / pageSize
}