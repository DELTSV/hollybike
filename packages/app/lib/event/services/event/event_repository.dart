import 'package:hollybike/event/types/event_details.dart';
import 'package:hollybike/event/types/event_form_data.dart';
import 'package:hollybike/event/types/event_status_state.dart';
import 'package:hollybike/journey/type/journey.dart';
import 'package:hollybike/shared/types/paginated_list.dart';

import '../../../journey/type/user_journey.dart';
import '../../../shared/utils/stream_mapper.dart';
import '../../types/event.dart';
import '../../types/minimal_event.dart';
import '../../types/participation/event_participation.dart';
import 'event_api.dart';

class EventRepository {
  final EventApi eventApi;

  final int numberOfEventsPerRequest = 10;

  final _eventDetailsStreamMapper =
      StreamMapper<EventDetails?>(seedValue: null);

  Stream<EventDetails?> eventDetailsStream(int eventId) =>
      _eventDetailsStreamMapper.stream(eventId);

  final _userStreamMapper = StreamMapper<List<MinimalEvent>>(seedValue: []);

  Stream<List<MinimalEvent>> userEventsStream(int userId) =>
      _userStreamMapper.stream(userId);

  final _futureEventsStreamCounter = StreamCounter<List<MinimalEvent>>([]);

  final _archivedEventsStreamCounter = StreamCounter<List<MinimalEvent>>([]);

  final _searchEventsStreamCounter = StreamCounter<List<MinimalEvent>>([]);

  Stream<List<MinimalEvent>> get futureStream =>
      _futureEventsStreamCounter.stream;

  Stream<List<MinimalEvent>> get archivedEventsStream =>
      _archivedEventsStreamCounter.stream;

  Stream<List<MinimalEvent>> get searchEventsStream =>
      _searchEventsStreamCounter.stream;

  String _lastQuery = "";

  EventRepository({required this.eventApi});

  Future<PaginatedList<MinimalEvent>> fetchEvents(
    String? requestType,
    int page, {
    int? userId,
    String? query,
  }) async {
    final pageResult = await eventApi.getEvents(
      requestType,
      page,
      numberOfEventsPerRequest,
      userId: userId,
      query: query,
    );

    if (userId != null && _userStreamMapper.containsKey(userId)) {
      _userStreamMapper.add(
        userId,
        _userStreamMapper.get(userId)! + pageResult.items,
      );

      return pageResult;
    }

    switch (requestType) {
      case "future":
        _futureEventsStreamCounter.add(
          _futureEventsStreamCounter.value + pageResult.items,
        );
        break;
      case "archived":
        _archivedEventsStreamCounter.add(
          _archivedEventsStreamCounter.value + pageResult.items,
        );
        break;
      default:
        _searchEventsStreamCounter.add(
          _searchEventsStreamCounter.value + pageResult.items,
        );
        break;
    }

    return pageResult;
  }

  Future<PaginatedList<MinimalEvent>> refreshEvents(
    String? requestType, {
    int? userId,
    String? query,
  }) async {
    if (query != null) {
      _lastQuery = query;
    }

    final pageResult = await eventApi.getEvents(
      requestType,
      0,
      numberOfEventsPerRequest,
      userId: userId,
      query: query,
    );

    if (userId != null) {
      _userStreamMapper.add(
        userId,
        pageResult.items,
      );

      return pageResult;
    }

    switch (requestType) {
      case "future":
        _futureEventsStreamCounter.add(
          pageResult.items,
        );
        break;
      case "archived":
        _archivedEventsStreamCounter.add(
          pageResult.items,
        );
        break;
      default:
        _searchEventsStreamCounter.add(
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

    _eventDetailsStreamMapper.add(eventId, eventDetails);

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

    final details = _eventDetailsStreamMapper.get(eventId);

    if (details == null) {
      return;
    }

    _eventDetailsStreamMapper.add(
        eventId, details.copyWith(event: editedEvent));

    for (var controller in [
          _futureEventsStreamCounter.subject,
          _archivedEventsStreamCounter.subject,
          _searchEventsStreamCounter.subject,
        ] +
        _userStreamMapper.subjects) {
      controller.add(
        controller.value
            .map((e) => e.id == eventId ? editedEvent.toMinimalEvent() : e)
            .toList(),
      );
    }
  }

  Future<void> publishEvent(int eventId) async {
    await eventApi.publishEvent(eventId);

    final details = _eventDetailsStreamMapper.get(eventId);

    if (details == null) {
      return;
    }

    _eventDetailsStreamMapper.add(
      eventId,
      details.copyWith(
        event: details.event.copyWith(status: EventStatusState.scheduled),
      ),
    );

    for (var controller in [
          _futureEventsStreamCounter.subject,
          _archivedEventsStreamCounter.subject,
          _searchEventsStreamCounter.subject,
        ] +
        _userStreamMapper.subjects) {
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
    final details = _eventDetailsStreamMapper.get(eventId);

    final participation = await eventApi.joinEvent(eventId);

    if (details == null) {
      return;
    }

    onParticipantsAdded([participation], eventId, firstAsCaller: true);
  }

  Future<void> leaveEvent(int eventId) async {
    final details = _eventDetailsStreamMapper.get(eventId);

    await eventApi.leaveEvent(eventId);

    if (details == null || details.callerParticipation == null) {
      return;
    }

    _eventDetailsStreamMapper.add(
      eventId,
      EventDetails(
        event: details.event,
        journey: details.journey,
        callerParticipation: null,
        previewParticipants: details.previewParticipants,
        previewParticipantsCount: details.previewParticipantsCount,
      ),
    );

    onParticipantRemoved(details.callerParticipation!.userId, eventId);
  }

  Future<void> deleteEvent(int eventId) async {
    await eventApi.deleteEvent(eventId);

    for (var userId in _userStreamMapper.keys) {
      refreshEvents("future", userId: userId);
    }

    if (_futureEventsStreamCounter.isListening) {
      refreshEvents("future");
    }

    if (_archivedEventsStreamCounter.isListening) {
      refreshEvents("archived");
    }

    if (_searchEventsStreamCounter.isListening) {
      refreshEvents(null, query: _lastQuery);
    }
  }

  Future<void> cancelEvent(int eventId) async {
    await eventApi.cancelEvent(eventId);

    final details = _eventDetailsStreamMapper.get(eventId);

    if (details == null) {
      return;
    }

    _eventDetailsStreamMapper.add(
      eventId,
      details.copyWith(
        event: details.event.copyWith(status: EventStatusState.canceled),
      ),
    );

    for (var controller in [
          _futureEventsStreamCounter.subject,
          _archivedEventsStreamCounter.subject,
          _searchEventsStreamCounter.subject,
        ] +
        _userStreamMapper.subjects) {
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
    final details = _eventDetailsStreamMapper.get(eventId);

    if (details == null) {
      return;
    }

    _eventDetailsStreamMapper.add(
      eventId,
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
    final details = _eventDetailsStreamMapper.get(eventId);

    if (details == null) {
      return;
    }

    final updatedPreviewParticipants = [
      ...details.previewParticipants,
      ...participants,
    ].take(5).toList();

    _eventDetailsStreamMapper.add(
      eventId,
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
    final details = _eventDetailsStreamMapper.get(eventId);

    if (details == null) {
      return;
    }

    _eventDetailsStreamMapper.add(
      eventId,
      details.copyWith(
        callerParticipation: details.callerParticipation?.copyWith(
          isImagesPublic: isPublic,
        ),
      ),
    );
  }

  Future<void> addJourneyToEvent(
    int eventId,
    Journey journey,
  ) async {
    await eventApi.addJourneyToEvent(eventId, journey.id);

    onEventJourneyUpdated(journey, eventId);
  }

  void onEventJourneyUpdated(Journey journey, int eventId) {
    final details = _eventDetailsStreamMapper.get(eventId);

    if (details == null) {
      return;
    }

    _eventDetailsStreamMapper.add(
      eventId,
      details.copyWith(
        journey: journey.toMinimalJourney(),
      ),
    );
  }

  Future<void> removeJourneyFromEvent(
    int eventId,
  ) async {
    await eventApi.removeJourneyFromEvent(eventId);

    final details = _eventDetailsStreamMapper.get(eventId);

    if (details == null) {
      return;
    }

    _eventDetailsStreamMapper.add(
      eventId,
      EventDetails(
        event: details.event,
        journey: null,
        callerParticipation: details.callerParticipation,
        previewParticipants: details.previewParticipants,
        previewParticipantsCount: details.previewParticipantsCount,
      ),
    );
  }

  Future<UserJourney> terminateUserJourney(
    int eventId,
  ) async {
    final userJourney = await eventApi.terminateUserJourney(eventId);

    final details = _eventDetailsStreamMapper.get(eventId);

    if (details == null) {
      return userJourney;
    }

    _eventDetailsStreamMapper.add(
      eventId,
      details.copyWith(
        callerParticipation: details.callerParticipation?.copyWith(
          journey: userJourney,
        ),
      ),
    );

    return userJourney;
  }

  onUserPositionSent(int eventId) {
    final caller = _eventDetailsStreamMapper.get(eventId)?.callerParticipation;

    if (caller?.hasRecordedPositions != false) {
      return;
    }

    _eventDetailsStreamMapper.add(
      eventId,
      _eventDetailsStreamMapper.get(eventId)?.copyWith(
            callerParticipation: caller?.copyWith(
              hasRecordedPositions: true,
            ),
          ),
    );
  }
}
