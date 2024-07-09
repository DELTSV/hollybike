import 'dart:io';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:hollybike/auth/services/auth_persistence.dart';
import 'package:hollybike/event/types/event_details.dart';
import 'package:hollybike/event/types/event_expense.dart';
import 'package:hollybike/event/types/event_form_data.dart';
import 'package:hollybike/event/types/event_status_state.dart';
import 'package:hollybike/journey/type/journey.dart';
import 'package:hollybike/shared/types/paginated_list.dart';
import 'package:hollybike/shared/utils/streams/stream_counter.dart';
import 'package:hollybike/shared/utils/streams/stream_value.dart';

import '../../../journey/type/user_journey.dart';
import '../../../shared/utils/streams/stream_mapper.dart';
import '../../types/event.dart';
import '../../types/minimal_event.dart';
import '../../types/participation/event_participation.dart';
import 'event_api.dart';

class EventRepository {
  final EventApi eventApi;

  final int numberOfEventsPerRequest = 10;

  final _eventDetailsStreamMapper = StreamMapper<EventDetails?, void>(
    seedValue: null,
    name: "event-details",
  );

  Stream<StreamValue<EventDetails?, void>> eventDetailsStream(int eventId) =>
      _eventDetailsStreamMapper.stream(eventId);

  final _userStreamMapper = StreamMapper<List<MinimalEvent>, RefreshedType>(
    seedValue: [],
    initialState: RefreshedType.none,
    name: "user-events",
  );

  Stream<StreamValue<List<MinimalEvent>, RefreshedType>> userEventsStream(
    int userId,
  ) =>
      _userStreamMapper.stream(userId);

  final _futureEventsStreamCounter =
      StreamCounter<List<MinimalEvent>, RefreshedType>(
    [],
    "future-events",
    initialState: RefreshedType.none,
  );

  final _archivedEventsStreamCounter =
      StreamCounter<List<MinimalEvent>, RefreshedType>(
    [],
    "archived-events",
    initialState: RefreshedType.none,
  );

  final _searchEventsStreamCounter =
      StreamCounter<List<MinimalEvent>, RefreshedType>(
    [],
    "search-events",
    initialState: RefreshedType.none,
  );

  Stream<StreamValue<List<MinimalEvent>, RefreshedType>> get futureStream =>
      _futureEventsStreamCounter.stream;

  Stream<StreamValue<List<MinimalEvent>, RefreshedType>>
      get archivedEventsStream => _archivedEventsStreamCounter.stream;

  Stream<StreamValue<List<MinimalEvent>, RefreshedType>>
      get searchEventsStream => _searchEventsStreamCounter.stream;

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
        state: pageResult.refreshedType,
      );

      return pageResult;
    }

    switch (requestType) {
      case "future":
        _futureEventsStreamCounter.add(
          pageResult.items,
          state: pageResult.refreshedType,
        );
        break;
      case "archived":
        _archivedEventsStreamCounter.add(
          pageResult.items,
          state: pageResult.refreshedType,
        );
        break;
      default:
        _searchEventsStreamCounter.add(
          pageResult.items,
          state: pageResult.refreshedType,
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
    final details = _eventDetailsStreamMapper.get(eventId);

    if (details == null) {
      return;
    }

    final editedEvent = await eventApi.editEvent(
      eventId,
      event.withBudget(
        details.event.budget,
      ),
    );

    _eventDetailsStreamMapper.add(
      eventId,
      details.copyWith(event: editedEvent),
    );

    for (var counter in [
          _futureEventsStreamCounter,
          _archivedEventsStreamCounter,
          _searchEventsStreamCounter,
        ] +
        _userStreamMapper.counters) {
      counter.add(
        counter.value
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

    for (var counter in [
          _futureEventsStreamCounter,
          _archivedEventsStreamCounter,
          _searchEventsStreamCounter,
        ] +
        _userStreamMapper.counters) {
      counter.add(
        counter.value
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

    final userId = details.callerParticipation!.userId;

    final events = _userStreamMapper.get(userId);

    if (events != null) {
      if (events.any((e) => e.id == eventId)) {
        await refreshEvents("future", userId: userId);
      }
    }

    _eventDetailsStreamMapper.add(
      eventId,
      EventDetails(
        expenses: details.expenses,
        totalExpense: details.totalExpense,
        event: details.event,
        journey: details.journey,
        callerParticipation: null,
        previewParticipants: details.previewParticipants,
        previewParticipantsCount: details.previewParticipantsCount,
      ),
    );

    onParticipantRemoved(userId, eventId);
  }

  Future<void> deleteEvent(int eventId) async {
    await eventApi.deleteEvent(eventId);

    for (var userId in _userStreamMapper.keys) {
      final events = _userStreamMapper.get(userId);

      if (events == null) {
        continue;
      }

      if (events.any((e) => e.id == eventId)) {
        refreshEvents("future", userId: userId);
      }
    }

    if (_futureEventsStreamCounter.isListening) {
      final events = _futureEventsStreamCounter.value;

      if (events.any((e) => e.id == eventId)) {
        refreshEvents("future");
      }
    }

    if (_archivedEventsStreamCounter.isListening) {
      final events = _archivedEventsStreamCounter.value;

      if (events.any((e) => e.id == eventId)) {
        refreshEvents("archived");
      }
    }

    if (_searchEventsStreamCounter.isListening) {
      final events = _searchEventsStreamCounter.value;

      if (events.any((e) => e.id == eventId)) {
        refreshEvents(null, query: _lastQuery);
      }
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

    for (var counter in [
          _futureEventsStreamCounter,
          _archivedEventsStreamCounter,
          _searchEventsStreamCounter,
        ] +
        _userStreamMapper.counters) {
      counter.add(
        counter.value
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
        expenses: details.expenses,
        totalExpense: details.totalExpense,
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

  deleteExpense(int expenseId, int eventId) async {
    await eventApi.deleteExpense(expenseId);

    final details = _eventDetailsStreamMapper.get(eventId);

    if (details == null) {
      return;
    }

    int? newTotal = details.totalExpense;

    final newExpenses = details.expenses?.where((e) {
      if (e.id == expenseId) {
        final totalExpense = details.totalExpense;
        if (totalExpense != null) {
          newTotal = totalExpense - e.amount;
        }
        return false;
      }

      return true;
    }).toList();

    _eventDetailsStreamMapper.add(
      eventId,
      details.copyWith(
        expenses: newExpenses,
        totalExpense: newTotal,
      ),
    );
  }

  Future<EventExpense> addExpense(
    int eventId,
    String name,
    int amount,
    String? description,
  ) async {
    final expense = await eventApi.addExpense(
      eventId,
      name,
      amount,
      description,
    );

    final details = _eventDetailsStreamMapper.get(eventId);

    if (details == null) {
      return expense;
    }

    final newTotal = (details.totalExpense ?? 0) + amount;

    final newExpenses = <EventExpense>[
      expense,
      ...details.expenses ?? [],
    ];

    _eventDetailsStreamMapper.add(
      eventId,
      details.copyWith(
        expenses: newExpenses,
        totalExpense: newTotal,
      ),
    );

    return expense;
  }

  Future<void> editBudget(
    int eventId,
    int? budget,
  ) async {
    final details = _eventDetailsStreamMapper.get(eventId);

    if (details == null) {
      return;
    }

    await eventApi.editEvent(
      eventId,
      EventFormData(
        name: details.event.name,
        description: details.event.description,
        startDate: details.event.startDate,
        endDate: details.event.endDate,
        budget: budget,
      ),
    );

    _eventDetailsStreamMapper.add(
      eventId,
      details.copyWith(
        event: Event(
          id: details.event.id,
          name: details.event.name,
          description: details.event.description,
          status: details.event.status,
          budget: budget,
          startDate: details.event.startDate,
          endDate: details.event.endDate,
          owner: details.event.owner,
          createdAt: details.event.createdAt,
          updatedAt: details.event.updatedAt,
          image: details.event.image,
        ),
      ),
    );
  }

  Future<void> downloadReport(int eventId) async {
    final authPersistence = AuthPersistence();

    final session = await authPersistence.currentSession;

    final details = _eventDetailsStreamMapper.get(eventId);

    if (session == null || details == null) {
      return;
    }

    final eventName = details.event.name.replaceAll(" ", "_").toLowerCase();

    await FlutterDownloader.enqueue(
      url: '${session.host}/api/events/$eventId/expenses/report',
      headers: {
        'Authorization': 'Bearer ${session.token}',
      },
      savedDir: "/storage/emulated/0/Download",
      fileName: "depenses_$eventName.csv",
      showNotification: true,
      openFileFromNotification: true,
    );
  }

  Future<void> uploadExpenseProof(
    int eventId,
    int expenseId,
    File image,
  ) async {
    final updatedExpense = await eventApi.uploadExpenseProof(
      expenseId,
      image,
    );

    final details = _eventDetailsStreamMapper.get(eventId);

    if (details == null) {
      return;
    }

    final newExpenses = details.expenses?.map((e) {
      if (e.id == expenseId) {
        return updatedExpense;
      }

      return e;
    }).toList();

    _eventDetailsStreamMapper.add(
      eventId,
      details.copyWith(
        expenses: newExpenses,
      ),
    );
  }
}
