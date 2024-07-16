/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.exceptions

class AlreadyParticipatingToEventException(message: String? = null) : RuntimeException(message)

class EventActionDeniedException(message: String? = null) : RuntimeException(message)

class EventNotFoundException(message: String? = null) : RuntimeException(message)

class NotParticipatingToEventException(message: String? = null) : RuntimeException(message)

class InvalidEventNameException(message: String? = null) : RuntimeException(message)

class InvalidEventDescriptionException(message: String? = null) : RuntimeException(message)

class JourneyNotFoundException(message: String? = null) : RuntimeException(message)