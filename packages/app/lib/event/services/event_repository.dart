import 'package:hollybike/auth/types/auth_session.dart';
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
}
