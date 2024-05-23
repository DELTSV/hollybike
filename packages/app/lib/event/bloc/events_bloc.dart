import 'package:bloc/bloc.dart';
import 'package:hollybike/event/bloc/events_event.dart';
import 'package:hollybike/event/services/event_repository.dart';
import 'package:hollybike/event/bloc/events_state.dart';
import 'package:hollybike/event/types/minimal_event.dart';
import 'package:hollybike/shared/types/paginated_list.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  final EventRepository eventRepository;
  final int numberOfEventsPerRequest = 10;

  EventsBloc({required this.eventRepository}) : super(const EventsState()) {
    on<LoadEventsNextPage>(_onLoadEventsNextPage);
    on<RefreshEvents>(_onRefreshEvents);
    on<CreateEvent>(_onCreateEvent);
  }

  Future<void> _onLoadEventsNextPage(
    LoadEventsNextPage event,
    Emitter<EventsState> emit,
  ) async {
    if (state.hasMore == false || state.status == EventStatus.loading) {
      return;
    }

    emit(EventPageLoadInProgress(state));

    PaginatedList<MinimalEvent> page = await eventRepository.fetchEvents(
      event.session,
      state.nextPage,
      numberOfEventsPerRequest,
    );

    emit(EventPageLoadSuccess(state.copyWith(
      events: [...state.events, ...page.items],
      hasMore: page.items.length == numberOfEventsPerRequest,
      nextPage: state.nextPage + 1,
    )));
  }

  Future<void> _onRefreshEvents(
    RefreshEvents event,
    Emitter<EventsState> emit,
  ) async {
    emit(EventPageLoadInProgress(const EventsState()));

    PaginatedList<MinimalEvent> page = await eventRepository.fetchEvents(
      event.session,
      0,
      numberOfEventsPerRequest,
    );

    emit(EventPageLoadSuccess(state.copyWith(
      events: page.items,
      hasMore: page.items.length == numberOfEventsPerRequest,
      nextPage: 1,
    )));
  }

  Future<void> _onCreateEvent(
    CreateEvent event,
    Emitter<EventsState> emit,
  ) async {
    // emit(state.loadInProgress);
    //
    // // Delay to simulate network request
    // await Future.delayed(const Duration(seconds: 2));
    //
    // emit(state.copyWith(
    //   events: [...state.events],
    // ).loadSuccess);
  }
}
