package hollybike.api.utils

private val emailRegexp = Regex("^(?! )[a-zA-Z0-9_.-]+@[a-zA-Z0-9_.-]+\\.[a-zA-Z0-9_-]{2,}$")

fun String.isValidMail(): Boolean = emailRegexp.matches(this)