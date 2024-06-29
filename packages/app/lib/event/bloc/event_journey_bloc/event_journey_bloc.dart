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

        final journeyWithPositions = await journeyRepository.getPositions(
          session,
          journeyWithFile.id,
        );

        eventRepository.onEventJourneyUpdated(journeyWithFile.copyWith(
          start: journeyWithPositions.start,
          end: journeyWithPositions.end,
          destination: journeyWithPositions.destination,
        ));

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
        event.session,
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
