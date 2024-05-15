import 'package:hollybike/auth/types/auth_session.dart';
import 'package:hollybike/event/bloc/event_api.dart';
import 'package:hollybike/shared/types/paginated_list.dart';

import '../types/event.dart';

class EventRepository {
  final EventApi eventApi;

  EventRepository({required this.eventApi});

  Future<PaginatedList<Event>> fetchEvents(AuthSession session) async {
    return eventApi.getEvents(session);
  }
}