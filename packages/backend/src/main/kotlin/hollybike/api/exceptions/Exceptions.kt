/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.exceptions

class BadRequestException(message: String? = null) : RuntimeException(message)

class InvalidDateException(message: String? = null) : RuntimeException(message)

class NotAllowedException(message: String? = null) : RuntimeException(message)

class NoMailSenderException(message: String? = null) : RuntimeException(message)