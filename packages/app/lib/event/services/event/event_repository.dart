import 'package:hollybike/auth/types/auth_session.dart';

import 'package:hollybike/event/types/event_details.dart';
import 'package:hollybike/event/types/event_form_data.dart';
import 'package:hollybike/event/types/event_status_state.dart';
import 'package:hollybike/journey/type/journey.dart';
import 'package:hollybike/shared/types/paginated_list.dart';
import 'package:rxdart/rxdart.dart';

import '../../types/event.dart';
import '../../types/minimal_event.dart';
import '../../types/participation/event_participation.dart';
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
    String requestType,
    int page,
    int eventsPerPage, {
    int? userId,
  }) async {
    final pageResult = await eventApi.getEvents(
      session,
      requestType,
      page,
      eventsPerPage,
    );

    _eventsStreamController.add(
      _eventsStreamController.value + pageResult.items,
    );

    return pageResult;
  }

  Future<PaginatedList<MinimalEvent>> refreshEvents(
    AuthSession session,
    String requestType,
    int eventsPerPage, {
    int? userId,
  }) async {
    final pageResult = await eventApi.getEvents(
      session,
      requestType,
      0,
      eventsPerPage,
      userId: userId,
    );

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

  Future<void> editEvent(
      AuthSession session, int eventId, EventFormData event) async {
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

    onParticipantsAdded([participation], firstAsCaller: true);
  }

  Future<void> leaveEvent(AuthSession session, int eventId) async {
    final details = _eventStreamController.value;

    await eventApi.leaveEvent(session, eventId);

    if (details == null || details.callerParticipation == null) {
      return;
    }

    onParticipantRemoved(details.callerParticipation!.userId);
  }

  Future<void> deleteEvent(AuthSession session, int eventId) async {
    return eventApi.deleteEvent(session, eventId);
  }

  Future<void> cancelEvent(AuthSession session, int eventId) async {
    final details = _eventStreamController.value!;

    await eventApi.cancelEvent(session, eventId);

    _eventStreamController.add(
      details.copyWith(
        event: details.event.copyWith(status: EventStatusState.canceled),
      ),
    );

    _eventsStreamController.add(
      _eventsStreamController.value
          .map((e) => e.id == eventId
              ? e.copyWith(status: EventStatusState.canceled)
              : e)
          .toList(),
    );
  }

  void onParticipantRemoved(int userId) {
    final details = _eventStreamController.value;

    if (details == null) {
      return;
    }

    _eventStreamController.add(
      details.copyWith(
        previewParticipants: details.previewParticipants
            .where((p) => p.user.id != userId)
            .toList(),
        previewParticipantsCount: details.previewParticipantsCount - 1,
      ),
    );
  }

  void onParticipantsAdded(List<EventParticipation> participants,
      {bool firstAsCaller = false}) {
    final details = _eventStreamController.value;

    if (details == null) {
      return;
    }

    final updatedPreviewParticipants = [
      ...details.previewParticipants,
      ...participants,
    ].take(5).toList();

    _eventStreamController.add(
      details.copyWith(
        previewParticipants: updatedPreviewParticipants,
        previewParticipantsCount:
            details.previewParticipantsCount + participants.length,
        callerParticipation: firstAsCaller
            ? participants.first.toEventCallerParticipation()
            : details.callerParticipation,
      ),
    );
  }

  void onImagesVisibilityUpdated(bool isPublic) {
    final details = _eventStreamController.value;

    if (details == null) {
      return;
    }

    _eventStreamController.add(
      details.copyWith(
        callerParticipation: details.callerParticipation?.copyWith(
          isImagesPublic: isPublic,
        ),
      ),
    );
  }

  Future<void> close() async {
    _eventStreamController.close();
    _eventsStreamController.close();
  }

  Future<void> addJourneyToEvent(
    AuthSession session,
    int eventId,
    Journey journey,
  ) async {
    await eventApi.addJourneyToEvent(session, eventId, journey.id);

    onEventJourneyUpdated(journey);
  }

  void onEventJourneyUpdated(Journey journey) {
    final details = _eventStreamController.value;

    if (details == null) {
      return;
    }

    _eventStreamController.add(
      details.copyWith(
        journey: journey.toMinimalJourney(),
      ),
    );
  }
}
