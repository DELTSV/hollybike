import 'package:hollybike/auth/types/auth_session.dart';

import 'package:hollybike/event/types/event_details.dart';
import 'package:hollybike/event/types/event_form_data.dart';
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

  Future<Event> createEvent(AuthSession session, EventFormData event) async {
    return eventApi.createEvent(session, event);
  }

  Future<void> editEvent(AuthSession session, int eventId, EventFormData event) async {
    final editedEvent = await eventApi.editEvent(session, eventId, event);

    final details = _eventStreamController.value;

    if (details == null) {
      return;
    }

    _eventStreamController.add(
      details.copyWith(
        event: editedEvent,
      ),
    );

    _eventsStreamController.add(
      _eventsStreamController.value
          .map((e) => e.id == eventId ? editedEvent.toMinimalEvent() : e)
          .toList(),
    );
  }

  Future<void> publishEvent(AuthSession session, int eventId) async {
    final details = _eventStreamController.value!;

    await eventApi.publishEvent(session, eventId);

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
  }

  Future<void> joinEvent(AuthSession session, int eventId) async {
    final details = _eventStreamController.value;

    final participation = await eventApi.joinEvent(session, eventId);

    if (details == null) {
      return;
    }

    final newCount = details.previewParticipantsCount + 1;

    if (details.previewParticipants.length < 5) {
      _eventStreamController.add(
        details.copyWith(
          previewParticipants: details.previewParticipants + [participation],
          previewParticipantsCount: newCount,
        ),
      );
    }

    _eventStreamController.add(
      details.copyWith(
        previewParticipantsCount: newCount,
      ),
    );
  }

  Future<void> leaveEvent(AuthSession session, int eventId) async {
    final details = _eventStreamController.value;

    await eventApi.leaveEvent(session, eventId);

    if (details == null) {
      return;
    }

    final newCount = details.previewParticipantsCount - 1;

    // if (details.previewParticipants.length <= 5) {
    //   _eventStreamController.add(
    //     details.copyWith(
    //       previewParticipants: details.previewParticipants
    //           .where((p) => p.user.id != session.userId)
    //           .toList(),
    //       previewParticipantsCount: newCount,
    //     ),
    //   );
    // }

    _eventStreamController.add(
      details.copyWith(
        previewParticipantsCount: newCount,
      ),
    );
  }

  Future<void> deleteEvent(AuthSession session, int eventId) async {
    return eventApi.deleteEvent(session, eventId);
  }

  Future<void> close() async {
    _eventStreamController.close();
    _eventsStreamController.close();
  }
}
