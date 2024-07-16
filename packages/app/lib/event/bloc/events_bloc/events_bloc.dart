/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:hollybike/event/types/minimal_event.dart';
import 'package:hollybike/shared/types/paginated_list.dart';
import 'package:hollybike/shared/utils/streams/stream_value.dart';

import '../../services/event/event_repository.dart';
import 'events_event.dart';
import 'events_state.dart';

abstract class EventsBloc extends Bloc<EventsEvent, EventsState> {
  final EventRepository eventRepository;
  final String requestType;

  EventsBloc({
    required this.eventRepository,
    required this.requestType,
  }) : super(EventInitial()) {
    on<SubscribeToEvents>(onSubscribeToEvents);
    on<LoadEventsNextPage>(onLoadEventsNextPage);
    on<RefreshEvents>(_onRefreshEvents);
  }

  Stream<StreamValue<List<MinimalEvent>, RefreshedType>> _getStream() {
    if (requestType == "future") {
      return eventRepository.futureStream;
    } else {
      return eventRepository.archivedEventsStream;
    }
  }

  Future<void> onSubscribeToEvents(
    SubscribeToEvents event,
    Emitter<EventsState> emit,
  ) async {
    await emit.forEach<StreamValue<List<MinimalEvent>, RefreshedType>>(
      _getStream(),
      onData: (data) {
        final events = data.value;
        final isRefreshed = data.state;

        if (isRefreshed == RefreshedType.none) {
          return state.copyWith(
            events: events,
          );
        }

        return EventPageLoadSuccess(
          state.copyWith(
            events: events,
            hasMore: isRefreshed == RefreshedType.refreshedAndHasMore,
            nextPage: 1,
          ),
        );
      },
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
        requestType,
        state.nextPage,
      );

      emit(
        EventPageLoadSuccess(
          state.copyWith(
            hasMore:
                page.items.length == eventRepository.numberOfEventsPerRequest,
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
    emit(EventPageLoadInProgress(state));

    try {
      await eventRepository.refreshEvents(
        requestType,
      );
    } catch (e) {
      emit(handleError(e, 'Error while refreshing events'));
    }
  }

  EventsState handleError(Object e, String logMessage) {
    log(logMessage, error: e);
    return EventPageLoadFailure(
      state.copyWith(
        events: [],
      ),
      errorMessage: 'Une erreur est survenue.',
    );
  }
}

extension FirstWhenNotLoading on EventsBloc {
  Future<EventsState> get firstWhenNotLoading async {
    return stream.firstWhere((state) {
      return state is! EventPageLoadInProgress;
    });
  }
}
