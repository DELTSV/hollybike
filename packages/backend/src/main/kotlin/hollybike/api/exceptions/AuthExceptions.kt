/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.exceptions

class InvitationNotFoundException(message: String? = null) : Exception(message)

class InvitationAlreadyExist(message: String? = null) : Exception(message)

class InvalidMailException(message: String? = null) : Exception(message)

class LinkExpire(message: String? = null) : Exception(message)

class PasswordInvalid(message: String? = null) : Exception(message)