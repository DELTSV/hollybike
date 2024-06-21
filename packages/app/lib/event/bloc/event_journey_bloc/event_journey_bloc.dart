import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:hollybike/journey/service/journey_repository.dart';

import '../../../journey/type/journey.dart';
import '../../services/event/event_repository.dart';
import 'event_journey_event.dart';
import 'event_journey_state.dart';

class EventJourneyBloc extends Bloc<EventJourneyEvent, EventJourneyState> {
  final JourneyRepository journeyRepository;
  final EventRepository eventRepository;

  EventJourneyBloc({
    required this.journeyRepository,
    required this.eventRepository,
  }) : super(EventJourneyInitial()) {
    on<UploadJourneyFileToEvent>(_onUploadJourneyFileToEvent);
    on<AttachJourneyToEvent>(_onAttachJourneyToEvent);
  }

  _onUploadJourneyFileToEvent(
    UploadJourneyFileToEvent event,
    Emitter<EventJourneyState> emit,
  ) async {
    emit(EventJourneyCreationInProgress(state));

    final session = event.session;

    Journey journey;

    try {
      journey = await journeyRepository.createJourney(
        session,
        event.name,
      );
    } catch (e) {
      emit(EventJourneyOperationFailure(
        state,
        errorMessage: 'Une erreur est survenue.',
      ));
      return;
    }

    emit(EventJourneyUploadInProgress(state));

    try {
      final journeyWithFile = await journeyRepository.uploadJourneyFile(
        session,
        journey.id,
        event.file,
      );

      emit(EventJourneyUploadSuccess(state));

      await eventRepository.addJourneyToEvent(
        session,
        event.eventId,
        journey,
      );

      eventRepository.onEventJourneyUpdated(journeyWithFile);

      emit(EventJourneyCreationSuccess(state));

      try {
        emit(EventJourneyGetPositionsInProgress(state));

        final journeyWithPositions = await journeyRepository.getPositions(session, journeyWithFile.id);
        eventRepository.onEventJourneyUpdated(journeyWithPositions);

        emit(EventJourneyGetPositionsSuccess(state));
      } catch (e) {
        log('Error while fetching positions for journey', error: e);
      }
    } catch (e) {
      emit(EventJourneyOperationFailure(
        state,
        errorMessage: 'Une erreur est survenue.',
      ));
    }
  }

  Future<void> _onAttachJourneyToEvent(
    AttachJourneyToEvent event,
    Emitter<EventJourneyState> emit,
  ) async {
    emit(EventJourneyOperationInProgress(state));

    try {
      await eventRepository.addJourneyToEvent(
        event.session,
        event.eventId,
        event.journey,
      );

      emit(EventJourneyOperationSuccess(
        state,
        successMessage: 'Parcours ajouté à l\'évènement',
      ));
    } catch (e) {
      log('Error while attaching journey to event', error: e);
      emit(EventJourneyOperationFailure(
        state,
        errorMessage: 'Impossible d\'ajouter le parcours à l\'évènement',
      ));
    }
  }
}
