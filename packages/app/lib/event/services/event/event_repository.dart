import 'package:hollybike/event/types/event_details.dart';
import 'package:hollybike/event/types/event_form_data.dart';
import 'package:hollybike/event/types/event_status_state.dart';
import 'package:hollybike/journey/type/journey.dart';
import 'package:hollybike/shared/types/paginated_list.dart';
import 'package:rxdart/rxdart.dart';

import '../../../journey/type/user_journey.dart';
import '../../types/event.dart';
import '../../types/minimal_event.dart';
import '../../types/participation/event_participation.dart';
import 'event_api.dart';

class EventRepository {
  final EventApi eventApi;
  late final _eventDetailsStreamController =
      BehaviorSubject<EventDetails?>.seeded(null);

  late final _futureStreamController =
      BehaviorSubject<List<MinimalEvent>>.seeded([]);

  late final _userStreamController =
      BehaviorSubject<List<MinimalEvent>>.seeded([]);

  late final _archivedStreamController =
      BehaviorSubject<List<MinimalEvent>>.seeded([]);

  late final _searchStreamController =
      BehaviorSubject<List<MinimalEvent>>.seeded([]);

  EventRepository({required this.eventApi});

  Stream<EventDetails?> get eventDetailsStream =>
      _eventDetailsStreamController.stream;

  Stream<List<MinimalEvent>> get futureStream => _futureStreamController.stream;

  Stream<List<MinimalEvent>> get userEventsStream =>
      _userStreamController.stream;

  Stream<List<MinimalEvent>> get archivedEventsStream =>
      _archivedStreamController.stream;

  Stream<List<MinimalEvent>> get searchEventsStream =>
      _searchStreamController.stream;

  Future<PaginatedList<MinimalEvent>> fetchEvents(
    String? requestType,
    int page,
    int eventsPerPage, {
    int? userId,
    String? query,
  }) async {
    final pageResult = await eventApi.getEvents(
      requestType,
      page,
      eventsPerPage,
      userId: userId,
      query: query,
    );

    if (userId != null) {
      _userStreamController.add(
        _userStreamController.value + pageResult.items,
      );

      return pageResult;
    }

    switch (requestType) {
      case "future":
        _futureStreamController.add(
          _futureStreamController.value + pageResult.items,
        );
        break;
      case "archived":
        _archivedStreamController.add(
          _archivedStreamController.value + pageResult.items,
        );
        break;
      default:
        _searchStreamController.add(
          _searchStreamController.value + pageResult.items,
        );
        break;
    }

    return pageResult;
  }

  Future<PaginatedList<MinimalEvent>> refreshEvents(
    String? requestType,
    int eventsPerPage, {
    int? userId,
    String? query,
  }) async {
    final pageResult = await eventApi.getEvents(
      requestType,
      0,
      eventsPerPage,
      userId: userId,
      query: query,
    );

    if (userId != null) {
      _userStreamController.add(
        pageResult.items,
      );

      return pageResult;
    }

    switch (requestType) {
      case "future":
        _futureStreamController.add(
          pageResult.items,
        );
        break;
      case "archived":
        _archivedStreamController.add(
          pageResult.items,
        );
        break;
      default:
        _searchStreamController.add(
          pageResult.items,
        );
        break;
    }

    return pageResult;
  }

  Future<EventDetails> fetchEventDetails(
    int eventId,
  ) async {
    final eventDetails = await eventApi.getEventDetails(eventId);

    _eventDetailsStreamController.add(eventDetails);

    return eventDetails;
  }

  Future<Event> createEvent(EventFormData event) async {
    return eventApi.createEvent(event);
  }

  Future<void> editEvent(
    int eventId,
    EventFormData event,
  ) async {
    final editedEvent = await eventApi.editEvent(eventId, event);

    final details = _eventDetailsStreamController.value;

    if (details == null) {
      return;
    }

    _eventDetailsStreamController.add(
      details.copyWith(
        event: editedEvent,
      ),
    );

    for (var controller in [
      _futureStreamController,
      _userStreamController,
      _archivedStreamController,
      _searchStreamController,
    ]) {
      controller.add(
        controller.value
            .map((e) => e.id == eventId ? editedEvent.toMinimalEvent() : e)
            .toList(),
      );
    }
  }

  Future<void> publishEvent(int eventId) async {
    final details = _eventDetailsStreamController.value!;

    await eventApi.publishEvent(eventId);

    _eventDetailsStreamController.add(
      details.copyWith(
        event: details.event.copyWith(status: EventStatusState.scheduled),
      ),
    );

    for (var controller in [
      _futureStreamController,
      _userStreamController,
      _archivedStreamController,
      _searchStreamController,
    ]) {
      controller.add(
        controller.value
            .map((e) => e.id == eventId
                ? e.copyWith(status: EventStatusState.scheduled)
                : e)
            .toList(),
      );
    }
  }

  Future<void> joinEvent(int eventId) async {
    final details = _eventDetailsStreamController.value;

    final participation = await eventApi.joinEvent(eventId);

    if (details == null) {
      return;
    }

    onParticipantsAdded([participation], firstAsCaller: true);
  }

  Future<void> leaveEvent(int eventId) async {
    final details = _eventDetailsStreamController.value;

    await eventApi.leaveEvent(eventId);

    if (details == null || details.callerParticipation == null) {
      return;
    }

    _eventDetailsStreamController.add(EventDetails(
      event: details.event,
      journey: details.journey,
      callerParticipation: null,
      previewParticipants: details.previewParticipants,
      previewParticipantsCount: details.previewParticipantsCount,
    ));

    onParticipantRemoved(details.callerParticipation!.userId);
  }

  Future<void> deleteEvent(int eventId) async {
    return eventApi.deleteEvent(eventId);
  }

  Future<void> cancelEvent(int eventId) async {
    final details = _eventDetailsStreamController.value!;

    await eventApi.cancelEvent(eventId);

    _eventDetailsStreamController.add(
      details.copyWith(
        event: details.event.copyWith(status: EventStatusState.canceled),
      ),
    );

    for (var controller in [
      _futureStreamController,
      _userStreamController,
      _archivedStreamController,
      _searchStreamController,
    ]) {
      controller.add(
        controller.value
            .map((e) => e.id == eventId
                ? e.copyWith(status: EventStatusState.canceled)
                : e)
            .toList(),
      );
    }
  }

  void onParticipantRemoved(int userId) {
    final details = _eventDetailsStreamController.value;

    if (details == null) {
      return;
    }

    _eventDetailsStreamController.add(
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
    final details = _eventDetailsStreamController.value;

    if (details == null) {
      return;
    }

    final updatedPreviewParticipants = [
      ...details.previewParticipants,
      ...participants,
    ].take(5).toList();

    _eventDetailsStreamController.add(
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
    final details = _eventDetailsStreamController.value;

    if (details == null) {
      return;
    }

    _eventDetailsStreamController.add(
      details.copyWith(
        callerParticipation: details.callerParticipation?.copyWith(
          isImagesPublic: isPublic,
        ),
      ),
    );
  }

  Future<void> close() async {
    _eventDetailsStreamController.close();
    _futureStreamController.close();
    _userStreamController.close();
    _archivedStreamController.close();
    _searchStreamController.close();
  }

  Future<void> addJourneyToEvent(
    int eventId,
    Journey journey,
  ) async {
    await eventApi.addJourneyToEvent(eventId, journey.id);

    onEventJourneyUpdated(journey);
  }

  void onEventJourneyUpdated(Journey journey) {
    final details = _eventDetailsStreamController.value;

    if (details == null) {
      return;
    }

    _eventDetailsStreamController.add(
      details.copyWith(
        journey: journey.toMinimalJourney(),
      ),
    );
  }

  Future<void> removeJourneyFromEvent(
    int eventId,
  ) async {
    await eventApi.removeJourneyFromEvent(eventId);

    final details = _eventDetailsStreamController.value;

    if (details == null) {
      return;
    }

    _eventDetailsStreamController.add(EventDetails(
      event: details.event,
      journey: null,
      callerParticipation: details.callerParticipation,
      previewParticipants: details.previewParticipants,
      previewParticipantsCount: details.previewParticipantsCount,
    ));
  }

  Future<UserJourney> terminateUserJourney(
    int eventId,
  ) async {
    final userJourney = await eventApi.terminateUserJourney(eventId);

    final details = _eventDetailsStreamController.value;

    if (details == null) {
      return userJourney;
    }

    _eventDetailsStreamController.add(
      details.copyWith(
        callerParticipation: details.callerParticipation?.copyWith(
          journey: userJourney,
        ),
      ),
    );

    return userJourney;
  }

  onUserPositionSent() {
    final caller = _eventDetailsStreamController.value?.callerParticipation;

    if (caller?.hasRecordedPositions != false) {
      return;
    }

    _eventDetailsStreamController.add(
      _eventDetailsStreamController.value!.copyWith(
        callerParticipation: _eventDetailsStreamController.value!.callerParticipation!.copyWith(
          hasRecordedPositions: true,
        ),
      ),
    );
  }
}
