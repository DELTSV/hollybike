package hollybike.api.exceptions

class InvitationDisabledException(message: String? = null): Exception(message)

class InvitationNotFoundException(message: String? = null): Exception(message)

class InvitationAlreadyExist(message: String? = null): Exception(message)

class InvalidMailException(message: String? = null): Exception(message)

class RoleDontExistException(message: String? = null): Exception(message)