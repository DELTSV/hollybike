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
  }

  _onUploadJourneyFileToEvent(
    UploadJourneyFileToEvent event,
    Emitter<EventJourneyState> emit,
  ) async {
    emit(EventJourneyCreationInProgress(state));

    Journey journey;

    try {
      journey = await journeyRepository.createJourney(
        event.session,
        event.name,
      );

      await eventRepository.addJourneyToEvent(
        event.session,
        event.eventId,
        journey,
      );

      emit(EventJourneyCreationSuccess(state));
    } catch (e) {
      emit(EventJourneyFailure(
        state,
        errorMessage: 'Une erreur est survenue.',
      ));
      return;
    }

    emit(EventJourneyUploadInProgress(state));

    try {
      final journeyWithFile = await journeyRepository.uploadJourneyFile(
        event.session,
        journey.id,
        event.file,
      );

      eventRepository.onEventJourneyUpdated(journeyWithFile);

      emit(EventJourneyUploadSuccess(state));
    } catch (e) {
      emit(EventJourneyFailure(
        state,
        errorMessage: 'Une erreur est survenue.',
      ));
      return;
    }
  }
}
