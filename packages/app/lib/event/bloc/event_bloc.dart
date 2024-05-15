import 'package:bloc/bloc.dart';
import 'package:hollybike/event/bloc/event_event.dart';
import 'package:hollybike/event/bloc/event_repository.dart';
import 'package:hollybike/event/bloc/event_state.dart';
import 'package:hollybike/event/types/event.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final EventRepository eventRepository;

  EventBloc({required this.eventRepository})
      : super(EventInitial()) {
    on<LoadEvents>(_onLoadEvents);
  }

  Future<void> _onLoadEvents(LoadEvents event, Emitter<EventState> emit) async {
    emit(EventLoadInProgress());
    List<Event> events = (await eventRepository.fetchEvents(event.session)).items;
    emit(EventLoadSuccess(events: events));
  }
}