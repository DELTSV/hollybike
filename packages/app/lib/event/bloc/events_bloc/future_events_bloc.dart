import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:hollybike/event/bloc/events_bloc/events_bloc.dart';

import 'events_event.dart';
import 'events_state.dart';

class FutureEventsBloc extends EventsBloc {
  FutureEventsBloc({required super.eventRepository}) : super(requestType: "future") {
    on<CreateEvent>(_onCreateEvent);
  }

  Future<void> _onCreateEvent(
      CreateEvent event,
      Emitter<EventsState> emit,
      ) async {
    emit(EventCreationInProgress(state));

    try {
      final createdEvent = await eventRepository.createEvent(
        event.session,
        event.formData,
      );

      emit(EventCreationSuccess(state, createdEvent: createdEvent));
    } catch (e) {
      log('Error while creating event', error: e);
      emit(EventCreationFailure(
        state,
        errorMessage: 'Une erreur est survenue.',
      ));
      return;
    }
  }
}
