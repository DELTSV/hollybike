/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
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
    on<RemoveJourneyFromEvent>(_onRemoveJourney);
  }

  _onUploadJourneyFileToEvent(
    UploadJourneyFileToEvent event,
    Emitter<EventJourneyState> emit,
  ) async {
    emit(EventJourneyCreationInProgress(state));

    Journey journey;

    try {
      journey = await journeyRepository.createJourney(
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
        journey.id,
        event.file,
      );

      emit(EventJourneyUploadSuccess(state));

      await eventRepository.addJourneyToEvent(
        event.eventId,
        journey,
      );

      eventRepository.onEventJourneyUpdated(journeyWithFile, event.eventId);

      emit(EventJourneyCreationSuccess(state));

      try {
        emit(EventJourneyGetPositionsInProgress(state));

        final journeyWithPositions = await journeyRepository.getPositions(
          journeyWithFile.id,
        );

        eventRepository.onEventJourneyUpdated(
          journeyWithFile.copyWith(
            start: journeyWithPositions.start,
            end: journeyWithPositions.end,
            destination: journeyWithPositions.destination,
          ),
          event.eventId,
        );

        emit(EventJourneyGetPositionsSuccess(state));
      } catch (e) {
        log('Error while fetching positions for journey', error: e);
      }
    } catch (e) {
      try {
        await journeyRepository.deleteJourney(journey.id);
      } catch (e) {
        log('Error while deleting journey', error: e);
      }

      emit(EventJourneyOperationFailure(
        state,
        errorMessage: 'Le ficher ne semble pas compatible.',
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
        event.eventId,
        event.journey,
      );

      emit(EventJourneyOperationSuccess(
        state,
        successMessage: 'Parcours mis à jour',
      ));
    } catch (e) {
      log('Error while attaching journey to event', error: e);
      emit(EventJourneyOperationFailure(
        state,
        errorMessage: 'Impossible de mettre à jour le parcours.',
      ));
    }
  }

  Future<void> _onRemoveJourney(
    RemoveJourneyFromEvent event,
    Emitter<EventJourneyState> emit,
  ) async {
    emit(EventJourneyOperationInProgress(state));

    try {
      await eventRepository.removeJourneyFromEvent(
        event.eventId,
      );

      emit(EventJourneyOperationSuccess(
        state,
        successMessage: 'Parcours retiré de l\'événement.',
      ));
    } catch (e) {
      log('Error while removing journey from event', error: e);
      emit(EventJourneyOperationFailure(
        state,
        errorMessage: 'Impossible de retirer le parcours.',
      ));
    }
  }
}
