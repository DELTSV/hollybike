import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:hollybike/event/types/event.dart';
import 'package:hollybike/event/types/event_details.dart';

import '../../services/event/event_repository.dart';
import '../../services/event_participations/event_participation_repository.dart';
import 'event_details_event.dart';
import 'event_details_state.dart';

class EventDetailsBloc extends Bloc<EventDetailsEvent, EventDetailsState> {
  final EventRepository _eventRepository;
  final EventParticipationRepository _eventParticipationRepository;

  EventDetailsBloc({
    required EventRepository eventRepository,
    required EventParticipationRepository eventParticipationRepository,
  })  : _eventRepository = eventRepository,
        _eventParticipationRepository = eventParticipationRepository,
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
    await emit.forEach<EventDetails?>(
      _eventRepository.eventDetailsStream,
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
      await _eventRepository.fetchEventDetails(
        event.session,
        event.eventId,
      );
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
        successMessage: 'Évènement publié',
      ));
    } catch (e) {
      log('Error while publishing event', error: e);
      emit(EventOperationFailure(state, errorMessage: e.toString()));
    }
  }
}
