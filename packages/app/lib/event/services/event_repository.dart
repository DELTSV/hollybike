import 'package:hollybike/auth/types/auth_session.dart';
import 'package:hollybike/event/types/create_event.dart';
import 'package:hollybike/event/types/event_status_state.dart';
import 'package:hollybike/shared/types/paginated_list.dart';
import 'package:rxdart/rxdart.dart';

import '../types/event.dart';
import '../types/minimal_event.dart';
import 'event_api.dart';

class EventRepository {
  final EventApi eventApi;
  late final _eventStreamController = BehaviorSubject<Event?>.seeded(null);
  late final _eventsStreamController = BehaviorSubject<List<MinimalEvent>>.seeded([]);

  EventRepository({required this.eventApi});

  Stream<Event?> get eventStream => _eventStreamController.stream;
  Stream<List<MinimalEvent>> get eventsStream => _eventsStreamController.stream;

  Future<PaginatedList<MinimalEvent>> fetchEvents(
    AuthSession session,
    int page,
    int eventsPerPage,
  ) async {
    final pageResult = await eventApi.getEvents(session, page, eventsPerPage);

    _eventsStreamController.add(
      _eventsStreamController.value + pageResult.items,
    );

    return pageResult;
  }

  Future<PaginatedList<MinimalEvent>> refreshEvents(
      AuthSession session,
      int eventsPerPage,
      ) async {
    final pageResult = await eventApi.getEvents(session, 0, eventsPerPage);

    _eventsStreamController.add(
      pageResult.items,
    );

    return pageResult;
  }

  Future<Event> fetchEvent(AuthSession session, int eventId) async {
    final event = await eventApi.getEvent(session, eventId);

    _eventStreamController.add(event);

    return event;
  }

  Future<Event> createEvent(AuthSession session, CreateEventDTO event) async {
    return eventApi.createEvent(session, event);
  }

  Future<void> publishEvent(AuthSession session, int eventId) async {
    _eventStreamController.add(
      _eventStreamController.value!
          .copyWith(status: EventStatusState.scheduled),
    );

    return eventApi.publishEvent(session, eventId);
  }

  Future<void> close() async {
    _eventStreamController.close();
  }
}
