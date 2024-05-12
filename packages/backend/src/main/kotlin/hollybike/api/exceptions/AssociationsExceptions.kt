package hollybike.api.exceptions

class AssociationNotFound(message: String? = null): Exception(message)

class AssociationAlreadyExists(message: String? = null): Exception(message)