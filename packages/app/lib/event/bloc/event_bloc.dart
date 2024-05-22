import 'package:bloc/bloc.dart';
import 'package:hollybike/event/bloc/event_event.dart';
import 'package:hollybike/event/bloc/event_repository.dart';
import 'package:hollybike/event/bloc/event_state.dart';
import 'package:hollybike/event/types/minimal_event.dart';
import 'package:hollybike/shared/types/paginated_list.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final EventRepository eventRepository;
  final int numberOfEventsPerRequest = 10;

  EventBloc({required this.eventRepository}) : super(EventInitial()) {
    on<LoadEventsNextPage>(_onLoadEventsNextPage);
    on<RefreshEvents>(_onRefreshEvents);
    on<LoadEventDetails>(_onLoadEventDetails);
    on<CreateEvent>(_onCreateEvent);
  }

  Future<void> _onLoadEventsNextPage(
    LoadEventsNextPage event,
    Emitter<EventState> emit,
  ) async {
    if (state.hasMore == false || state.status == EventStatus.loading) {
      return;
    }

    emit(state.loadInProgress);
    PaginatedList<MinimalEvent> page = await eventRepository.fetchEvents(
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
    emit(state.initial);
    emit(state.loadInProgress);
    PaginatedList<MinimalEvent> page = await eventRepository.fetchEvents(
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

  Future<void> _onLoadEventDetails(
    LoadEventDetails event,
    Emitter<EventState> emit,
  ) async {
    emit(state.loadInProgress);

    final eventDetails = await eventRepository.fetchEvent(
      event.session,
      event.eventId,
    );

    emit(state
        .copyWith(
          event: eventDetails,
        )
        .loadSuccess);
  }

  Future<void> _onCreateEvent(
    CreateEvent event,
    Emitter<EventState> emit,
  ) async {
    emit(state.loadInProgress);

    // Delay to simulate network request
    await Future.delayed(const Duration(seconds: 2));

    emit(state.copyWith(
      events: [...state.events],
    ).loadSuccess);
  }
}
