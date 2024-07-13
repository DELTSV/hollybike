package hollybike.api.exceptions

class InvitationNotFoundException(message: String? = null) : Exception(message)

class InvitationAlreadyExist(message: String? = null) : Exception(message)

class InvalidMailException(message: String? = null) : Exception(message)

class LinkExpire(message: String? = null) : Exception(message)