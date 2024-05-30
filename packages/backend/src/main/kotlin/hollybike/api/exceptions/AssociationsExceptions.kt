package hollybike.api.exceptions

class AssociationNotFound(message: String? = null): Exception(message)

class AssociationAlreadyExists(message: String? = null): Exception(message)

class AssociationOnboardingUserNotEditedException(message: String? = null): Exception(message)

class AssociationsOnboardingAssociationNotEditedException(message: String? = null): Exception(message)

class AssociationsOnboardingNotCompletedException(message: String? = null): Exception(message)