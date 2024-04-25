package hollybike.api.exceptions

class UserNotFoundException(override val message: String? = null) : Exception(message)

class UserWrongPassword(override val message: String? = null) : Exception(message)

class UserDifferentNewPassword(override val message: String? = null) : Exception(message)