import 'package:hollybike/auth/types/auth_session.dart';
import 'package:hollybike/event/types/create_event.dart';
import 'package:hollybike/event/types/event_details.dart';
import 'package:hollybike/event/types/event_status_state.dart';
import 'package:hollybike/shared/types/paginated_list.dart';
import 'package:rxdart/rxdart.dart';

import '../../types/event.dart';
import '../../types/minimal_event.dart';
import 'event_api.dart';

class EventRepository {
  final EventApi eventApi;
  late final _eventStreamController =
      BehaviorSubject<EventDetails?>.seeded(null);
  late final _eventsStreamController =
      BehaviorSubject<List<MinimalEvent>>.seeded([]);

  EventRepository({required this.eventApi});

  Stream<EventDetails?> get eventDetailsStream => _eventStreamController.stream;

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

  Future<EventDetails> fetchEventDetails(
      AuthSession session, int eventId) async {
    final eventDetails = await eventApi.getEventDetails(session, eventId);

    _eventStreamController.add(eventDetails);

    return eventDetails;
  }

  Future<Event> createEvent(AuthSession session, CreateEventDTO event) async {
    return eventApi.createEvent(session, event);
  }

  Future<void> publishEvent(AuthSession session, int eventId) async {
    final details = _eventStreamController.value!;

    _eventStreamController.add(
      details.copyWith(
        event: details.event.copyWith(status: EventStatusState.scheduled),
      ),
    );

    _eventsStreamController.add(
      _eventsStreamController.value
          .map((e) => e.id == eventId
              ? e.copyWith(status: EventStatusState.scheduled)
              : e)
          .toList(),
    );

    return eventApi.publishEvent(session, eventId);
  }

  Future<void> close() async {
    _eventStreamController.close();
  }
}
