import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:hollybike/event/bloc/event_details_event.dart';
import 'package:hollybike/event/bloc/event_details_state.dart';
import 'package:hollybike/event/services/event_repository.dart';
import 'package:hollybike/event/types/event.dart';

class EventDetailsBloc extends Bloc<EventDetailsEvent, EventDetailsState> {
  final EventRepository _eventRepository;

  EventDetailsBloc({required EventRepository eventRepository})
      : _eventRepository = eventRepository,
        super(const EventDetailsState()) {
    on<SubscribeToEvent>(_onSubscribeToEvent);
    on<LoadEventDetails>(_onLoadEventDetails);
    on<PublishEvent>(_onPublishEvent);
  }

  @override
  Future<void> close() async {
    await _eventRepository.close();
    return super.close();
  }

  Future<void> _onSubscribeToEvent(
    SubscribeToEvent event,
    Emitter<EventDetailsState> emit,
  ) async {
    await emit.forEach<Event?>(
      _eventRepository.eventStream,
      onData: (event) => state.copyWith(
        event: event,
      ),
    );
  }

  Future<void> _onLoadEventDetails(
    LoadEventDetails event,
    Emitter<EventDetailsState> emit,
  ) async {
    emit(EventDetailsLoadInProgress(state));

    try {
      await _eventRepository.fetchEvent(
        event.session,
        event.eventId,
      );

      emit(EventDetailsLoadSuccess(state));
    } catch (e) {
      log('Error while loading event details', error: e);
      emit(EventDetailsLoadFailure(state, errorMessage: e.toString()));
    }
  }

  Future<void> _onPublishEvent(
    PublishEvent event,
    Emitter<EventDetailsState> emit,
  ) async {
    emit(EventOperationInProgress(state));

    try {
      await _eventRepository.publishEvent(
        event.session,
        event.eventId,
      );

      emit(EventOperationSuccess(
        state,
        successMessage: 'Evénement publié avec succès',
      ));
    } catch (e) {
      log('Error while publishing event', error: e);
      emit(EventOperationFailure(state, errorMessage: e.toString()));
    }
  }
}
