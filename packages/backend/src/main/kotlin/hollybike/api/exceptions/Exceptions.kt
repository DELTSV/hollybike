package hollybike.api.exceptions

class BadRequestException(message: String? = null) : RuntimeException(message)

class InvalidDateException(message: String? = null) : RuntimeException(message)