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

  final _eventDetailsStreamControllerMap = <int, BehaviorSubject<EventDetails?>>{};

  final _futureStreamController =
      BehaviorSubject<List<MinimalEvent>>.seeded([]);

  final _userStreamController =
      BehaviorSubject<List<MinimalEvent>>.seeded([]);

  final _archivedStreamController =
      BehaviorSubject<List<MinimalEvent>>.seeded([]);

  final _searchStreamController =
      BehaviorSubject<List<MinimalEvent>>.seeded([]);

  EventRepository({required this.eventApi});

  Stream<EventDetails?> getEventDetailsStream(int eventId) =>
      _eventDetailsStreamControllerMap.putIfAbsent(
        eventId,
        () => BehaviorSubject<EventDetails?>.seeded(null),
      ).stream;

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

    _eventDetailsStreamControllerMap[eventId]?.add(eventDetails);

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

    final details = _eventDetailsStreamControllerMap[eventId]?.value;

    if (details == null) {
      return;
    }

    _eventDetailsStreamControllerMap[eventId]?.add(
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
    await eventApi.publishEvent(eventId);

    final details = _eventDetailsStreamControllerMap[eventId]?.value;

    if (details == null) {
      return;
    }

    _eventDetailsStreamControllerMap[eventId]?.add(
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
    final details = _eventDetailsStreamControllerMap[eventId]?.value;

    final participation = await eventApi.joinEvent(eventId);

    if (details == null) {
      return;
    }

    onParticipantsAdded([participation], eventId, firstAsCaller: true);
  }

  Future<void> leaveEvent(int eventId) async {
    final details = _eventDetailsStreamControllerMap[eventId]?.value;

    await eventApi.leaveEvent(eventId);

    if (details == null || details.callerParticipation == null) {
      return;
    }

    _eventDetailsStreamControllerMap[eventId]?.add(EventDetails(
      event: details.event,
      journey: details.journey,
      callerParticipation: null,
      previewParticipants: details.previewParticipants,
      previewParticipantsCount: details.previewParticipantsCount,
    ));

    onParticipantRemoved(details.callerParticipation!.userId, eventId);
  }

  Future<void> deleteEvent(int eventId) async {
    return eventApi.deleteEvent(eventId);
  }

  Future<void> cancelEvent(int eventId) async {
    await eventApi.cancelEvent(eventId);

    final details = _eventDetailsStreamControllerMap[eventId]?.value!;

    if (details == null) {
      return;
    }

    _eventDetailsStreamControllerMap[eventId]?.add(
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

  void onParticipantRemoved(int userId, int eventId) {
    final details = _eventDetailsStreamControllerMap[eventId]?.value;

    if (details == null) {
      return;
    }

    _eventDetailsStreamControllerMap[eventId]?.add(
      details.copyWith(
        previewParticipants: details.previewParticipants
            .where((p) => p.user.id != userId)
            .toList(),
        previewParticipantsCount: details.previewParticipantsCount - 1,
      ),
    );
  }

  void onParticipantsAdded(List<EventParticipation> participants, int eventId,
      {bool firstAsCaller = false}) {
    final details = _eventDetailsStreamControllerMap[eventId]?.value;

    if (details == null) {
      return;
    }

    final updatedPreviewParticipants = [
      ...details.previewParticipants,
      ...participants,
    ].take(5).toList();

    _eventDetailsStreamControllerMap[eventId]?.add(
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

  void onImagesVisibilityUpdated(bool isPublic, int eventId) {
    final details = _eventDetailsStreamControllerMap[eventId]?.value;

    if (details == null) {
      return;
    }

    _eventDetailsStreamControllerMap[eventId]?.add(
      details.copyWith(
        callerParticipation: details.callerParticipation?.copyWith(
          isImagesPublic: isPublic,
        ),
      ),
    );
  }

  void close(int eventId) async {
    _eventDetailsStreamControllerMap[eventId]?.close();
    _eventDetailsStreamControllerMap.remove(eventId);
  }

  Future<void> addJourneyToEvent(
    int eventId,
    Journey journey,
  ) async {
    await eventApi.addJourneyToEvent(eventId, journey.id);

    onEventJourneyUpdated(journey, eventId);
  }

  void onEventJourneyUpdated(Journey journey, int eventId) {
    final details = _eventDetailsStreamControllerMap[eventId]?.value;

    if (details == null) {
      return;
    }

    _eventDetailsStreamControllerMap[eventId]?.add(
      details.copyWith(
        journey: journey.toMinimalJourney(),
      ),
    );
  }

  Future<void> removeJourneyFromEvent(
    int eventId,
  ) async {
    await eventApi.removeJourneyFromEvent(eventId);

    final details = _eventDetailsStreamControllerMap[eventId]?.value;

    if (details == null) {
      return;
    }

    _eventDetailsStreamControllerMap[eventId]?.add(EventDetails(
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

    final details = _eventDetailsStreamControllerMap[eventId]?.value;

    if (details == null) {
      return userJourney;
    }

    _eventDetailsStreamControllerMap[eventId]?.add(
      details.copyWith(
        callerParticipation: details.callerParticipation?.copyWith(
          journey: userJourney,
        ),
      ),
    );

    return userJourney;
  }

  onUserPositionSent(int eventId) {
    final caller = _eventDetailsStreamControllerMap[eventId]?.value?.callerParticipation;

    if (caller?.hasRecordedPositions != false) {
      return;
    }

    _eventDetailsStreamControllerMap[eventId]?.add(
      _eventDetailsStreamControllerMap[eventId]?.value!.copyWith(
        callerParticipation: _eventDetailsStreamControllerMap[eventId]?.value!.callerParticipation!.copyWith(
          hasRecordedPositions: true,
        ),
      ),
    );
  }
}
