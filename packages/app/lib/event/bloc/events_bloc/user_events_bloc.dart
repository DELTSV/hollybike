import 'package:bloc/bloc.dart';
import 'package:hollybike/event/bloc/events_bloc/events_bloc.dart';
import 'package:hollybike/shared/utils/stream_mapper.dart';

import '../../../shared/types/paginated_list.dart';
import '../../types/minimal_event.dart';
import 'events_event.dart';
import 'events_state.dart';

class UserEventsBloc extends EventsBloc {
  final int userId;

  UserEventsBloc({required super.eventRepository, required this.userId})
      : super(requestType: "future") {
    on<RefreshUserEvents>(_onRefreshUserEvents);
  }

  @override
  Future<void> onSubscribeToEvents(
    SubscribeToEvents event,
    Emitter<EventsState> emit,
  ) async {
    await emit.forEach<StreamValue<List<MinimalEvent>>>(
      eventRepository.userEventsStream(userId),
      onData: (data) {
        final events = data.value;
        final isRefreshed = data.refreshed;

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

  Future<void> _onRefreshUserEvents(
    RefreshUserEvents event,
    Emitter<EventsState> emit,
  ) async {
    emit(EventPageLoadInProgress(state));

    try {
      await eventRepository.refreshEvents(
        requestType,
        userId: userId,
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
        requestType,
        state.nextPage,
        userId: userId,
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
}
