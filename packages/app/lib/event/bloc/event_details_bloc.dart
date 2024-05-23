import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:hollybike/event/bloc/event_details_event.dart';
import 'package:hollybike/event/bloc/event_details_state.dart';
import 'package:hollybike/event/services/event_repository.dart';

class EventDetailsBloc extends Bloc<EventDetailsEvent, EventDetailsState> {
  final EventRepository eventRepository;
  final int numberOfEventsPerRequest = 10;

  EventDetailsBloc({required this.eventRepository})
      : super(const EventDetailsState()) {
    on<LoadEventDetails>(_onLoadEventDetails);
  }

  Future<void> _onLoadEventDetails(
    LoadEventDetails event,
    Emitter<EventDetailsState> emit,
  ) async {
    emit(EventDetailsLoadInProgress(state));

    try {
      final eventDetails = await eventRepository.fetchEvent(
        event.session,
        event.eventId,
      );

      emit(EventDetailsLoadSuccess(state.copyWith(
        event: eventDetails,
      )));
    } catch (e) {
      log('Error while loading event details', error: e);
      emit(EventDetailsLoadFailure(state, errorMessage: e.toString()));
    }
  }
}
