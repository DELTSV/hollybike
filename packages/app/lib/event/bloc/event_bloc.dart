import 'package:bloc/bloc.dart';
import 'package:hollybike/event/bloc/event_event.dart';
import 'package:hollybike/event/bloc/event_repository.dart';
import 'package:hollybike/event/bloc/event_state.dart';
import 'package:hollybike/event/types/event.dart';
import 'package:hollybike/shared/types/paginated_list.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final EventRepository eventRepository;
  final int numberOfEventsPerRequest = 10;

  EventBloc({required this.eventRepository}) : super(EventInitial()) {
    on<LoadEventsNextPage>(_onLoadEventsNextPage);
    on<RefreshEvents>(_onRefreshEvents);
  }

  Future<void> _onLoadEventsNextPage(
    LoadEventsNextPage event,
    Emitter<EventState> emit,
  ) async {
    if (state.hasMore == false || state.status == EventStatus.loading) {
      return;
    }

    emit(state.loadInProgress);
    PaginatedList<Event> page = await eventRepository.fetchEvents(
      event.session,
      state.nextPage,
      numberOfEventsPerRequest,
    );

    emit(state.loadSuccess.copyWith(
      events: [...state.events, ...page.items],
      hasMore: page.items.length == numberOfEventsPerRequest,
      nextPage: state.nextPage + 1,
    ));
  }

  Future<void> _onRefreshEvents(
    RefreshEvents event,
    Emitter<EventState> emit,
  ) async {
    emit(state.loadInProgress);
    PaginatedList<Event> page = await eventRepository.fetchEvents(
      event.session,
      0,
      numberOfEventsPerRequest,
    );
    emit(state.loadSuccess.copyWith(
      events: page.items,
      hasMore: page.items.length == numberOfEventsPerRequest,
      nextPage: 1,
    ));
  }
}
