/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.exceptions

class AssociationNotFound(message: String? = null): Exception(message)

class AssociationAlreadyExists(message: String? = null): Exception(message)

class AssociationOnboardingUserNotEditedException(message: String? = null): Exception(message)

class AssociationsOnboardingAssociationNotEditedException(message: String? = null): Exception(message)

class AssociationsOnboardingNotCompletedException(message: String? = null): Exception(message)