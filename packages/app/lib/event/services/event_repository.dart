import 'package:hollybike/auth/types/auth_session.dart';
import 'package:hollybike/event/types/create_event.dart';
import 'package:hollybike/shared/types/paginated_list.dart';

import '../types/event.dart';
import '../types/minimal_event.dart';
import 'event_api.dart';

class EventRepository {
  final EventApi eventApi;

  EventRepository({required this.eventApi});

  Future<PaginatedList<MinimalEvent>> fetchEvents(
    AuthSession session,
    int page,
    int eventsPerPage,
  ) async {
    return eventApi.getEvents(session, page, eventsPerPage);
  }

  Future<Event> fetchEvent(AuthSession session, int eventId) async {
    return eventApi.getEvent(session, eventId);
  }

  Future<Event> createEvent(AuthSession session, CreateEventDTO event) async {
    return eventApi.createEvent(session, event);
  }
}
