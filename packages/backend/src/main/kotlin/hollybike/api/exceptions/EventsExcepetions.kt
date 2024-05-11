package hollybike.api.exceptions

class AlreadyParticipatingToEventException(message: String? = null) : RuntimeException(message)

class EventActionDeniedException(message: String? = null) : RuntimeException(message)

class EventNotFoundException(message: String? = null) : RuntimeException(message)

class NotParticipatingToEventException(message: String? = null) : RuntimeException(message)

class InvalidEventNameException(message: String? = null) : RuntimeException(message)

class InvalidEventDescriptionException(message: String? = null) : RuntimeException(message)