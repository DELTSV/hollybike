import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:hollybike/event/types/minimal_event.dart';
import 'package:hollybike/shared/types/paginated_list.dart';

import '../../services/event/event_repository.dart';
import 'events_event.dart';
import 'events_state.dart';

abstract class EventsBloc extends Bloc<EventsEvent, EventsState> {
  final EventRepository eventRepository;
  final int numberOfEventsPerRequest = 10;
  final String requestType;

  EventsBloc({
    required this.eventRepository,
    required this.requestType,
  }) : super(EventInitial()) {
    on<SubscribeToEvents>(_onSubscribeToEvents);
    on<LoadEventsNextPage>(onLoadEventsNextPage);
    on<RefreshEvents>(_onRefreshEvents);
  }

  @override
  Future<void> close() async {
    await eventRepository.close();
    return super.close();
  }

  Future<void> _onSubscribeToEvents(
    SubscribeToEvents event,
    Emitter<EventsState> emit,
  ) async {
    await emit.forEach<List<MinimalEvent>>(
      eventRepository.eventsStream,
      onData: (events) => state.copyWith(
        events: events,
      ),
    );
  }

  Future<void> onLoadEventsNextPage(
    LoadEventsNextPage event,
    Emitter<EventsState> emit,
  ) async {
    if (state.hasMore == false || state.status == EventStatus.loading) {
      return;
    }

    emit(EventPageLoadInProgress(state));

    try {
      PaginatedList<MinimalEvent> page = await eventRepository.fetchEvents(
        event.session,
        requestType,
        state.nextPage,
        numberOfEventsPerRequest,
      );

      emit(
        EventPageLoadSuccess(
          state.copyWith(
            hasMore: page.items.length == numberOfEventsPerRequest,
            nextPage: state.nextPage + 1,
          ),
        ),
      );
    } catch (e) {
      emit(handleError(e, 'Error while loading next page of events'));
    }
  }

  Future<void> _onRefreshEvents(
    RefreshEvents event,
    Emitter<EventsState> emit,
  ) async {
    emit(EventPageLoadInProgress(const EventsState()));

    try {
      PaginatedList<MinimalEvent> page = await eventRepository.refreshEvents(
        event.session,
        requestType,
        numberOfEventsPerRequest,
      );

      emit(
        EventPageLoadSuccess(
          state.copyWith(
            hasMore: page.items.length == numberOfEventsPerRequest,
            nextPage: 1,
          ),
        ),
      );
    } catch (e) {
      emit(handleError(e, 'Error while refreshing events'));
    }
  }

  EventsState handleError(Object e, String logMessage) {
    log(logMessage, error: e);
    return EventPageLoadFailure(
      state,
      errorMessage: 'Une erreur est survenue.',
    );
  }
}
