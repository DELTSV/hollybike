import 'package:bloc/bloc.dart';
import 'package:hollybike/event/bloc/events_bloc/events_bloc.dart';

import '../../../shared/types/paginated_list.dart';
import '../../types/minimal_event.dart';
import 'events_event.dart';
import 'events_state.dart';

class UserEventsBloc extends EventsBloc {
  late int userId;

  UserEventsBloc({required super.eventRepository})
      : super(requestType: "future") {
    on<RefreshUserEvents>(_onRefreshUserEvents);
  }

  @override
  Future<void> onSubscribeToEvents(
      SubscribeToEvents event,
      Emitter<EventsState> emit,
      ) async {
    await emit.forEach<List<MinimalEvent>>(
      eventRepository.userEventsStream,
      onData: (events) => state.copyWith(
        events: events,
      ),
    );
  }

  Future<void> _onRefreshUserEvents(
    RefreshUserEvents event,
    Emitter<EventsState> emit,
  ) async {
    userId = event.userId;
    emit(EventPageLoadInProgress(state));

    try {
      PaginatedList<MinimalEvent> page = await eventRepository.refreshEvents(
        event.session,
        requestType,
        numberOfEventsPerRequest,
        userId: userId,
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

  @override
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
        userId: userId,
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
}
