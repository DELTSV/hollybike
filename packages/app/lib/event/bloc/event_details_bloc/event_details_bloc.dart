import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:hollybike/event/types/event_details.dart';

import '../../services/event/event_repository.dart';
import 'event_details_event.dart';
import 'event_details_state.dart';

class EventDetailsBloc extends Bloc<EventDetailsEvent, EventDetailsState> {
  final EventRepository _eventRepository;
  final int eventId;

  EventDetailsBloc({
    required EventRepository eventRepository,
    required this.eventId,
  })  : _eventRepository = eventRepository,
        super(const EventDetailsState()) {
    on<SubscribeToEvent>(_onSubscribeToEvent);
    on<LoadEventDetails>(_onLoadEventDetails);
    on<PublishEvent>(_onPublishEvent);
    on<JoinEvent>(_onJoinEvent);
    on<LeaveEvent>(_onLeaveEvent);
    on<EditEvent>(_onEditEvent);
    on<DeleteEvent>(_onDeleteEvent);
    on<CancelEvent>(_onCancelEvent);
    on<TerminateUserJourney>(_onTerminateUserJourney);
  }

  @override
  Future<void> close() async {
    _eventRepository.close(eventId);
    print("close event details bloc $eventId");
    return super.close();
  }

  Future<void> _onSubscribeToEvent(
    SubscribeToEvent event,
    Emitter<EventDetailsState> emit,
  ) async {
    await emit.forEach<EventDetails?>(
      _eventRepository.getEventDetailsStream(eventId),
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
      await _eventRepository.fetchEventDetails(eventId);
    } catch (e) {
      log('Error while loading event details', error: e);
      emit(EventDetailsLoadFailure(
        state,
        errorMessage: 'Impossible de charger les détails de l\'évènement',
      ));
    }
  }

  Future<void> _onPublishEvent(
    PublishEvent event,
    Emitter<EventDetailsState> emit,
  ) async {
    emit(EventOperationInProgress(state));

    try {
      await _eventRepository.publishEvent(eventId);

      emit(EventOperationSuccess(
        state,
        successMessage: 'Évènement publié',
      ));
    } catch (e) {
      log('Error while publishing event', error: e);
      emit(EventOperationFailure(
        state,
        errorMessage: 'Impossible de publier l\'évènement',
      ));
    }
  }

  Future<void> _onEditEvent(
    EditEvent event,
    Emitter<EventDetailsState> emit,
  ) async {
    emit(EventOperationInProgress(state));

    try {
      await _eventRepository.editEvent(
        eventId,
        event.formData.copyWith(
          startDate: event.formData.startDate.toUtc(),
          endDate: event.formData.endDate?.toUtc(),
        ),
      );

      emit(EventOperationSuccess(
        state,
        successMessage: 'Évènement modifié',
      ));
    } catch (e) {
      log('Error while editing event', error: e);
      emit(EventOperationFailure(
        state,
        errorMessage: 'Impossible de modifier l\'évènement',
      ));
    }
  }

  Future<void> _onJoinEvent(
    JoinEvent event,
    Emitter<EventDetailsState> emit,
  ) async {
    emit(EventOperationInProgress(state));

    try {
      await _eventRepository.joinEvent(eventId);

      emit(EventOperationSuccess(
        state,
        successMessage: 'Vous avez rejoint l\'évènement',
      ));
    } catch (e) {
      log('Error while publishing event', error: e);
      emit(EventOperationFailure(
        state,
        errorMessage: 'Impossible de rejoindre l\'évènement',
      ));
    }
  }

  Future<void> _onLeaveEvent(
    LeaveEvent event,
    Emitter<EventDetailsState> emit,
  ) async {
    emit(EventOperationInProgress(state));

    try {
      await _eventRepository.leaveEvent(eventId);

      emit(EventOperationSuccess(
        state,
        successMessage: 'Vous avez quitté l\'évènement',
      ));

      emit(LeaveEventSuccess(state));
    } catch (e) {
      log('Error while leaving event', error: e);
      emit(EventOperationFailure(
        state,
        errorMessage: 'Impossible de quitter l\'évènement',
      ));
    }
  }

  Future<void> _onDeleteEvent(
    DeleteEvent event,
    Emitter<EventDetailsState> emit,
  ) async {
    emit(DeleteEventInProgress(state));

    try {
      await _eventRepository.deleteEvent(eventId);

      emit(DeleteEventSuccess(state));
    } catch (e) {
      log('Error while deleting event', error: e);
      emit(DeleteEventFailure(
        state,
        errorMessage: 'Impossible de supprimer l\'évènement',
      ));
    }
  }

  Future<void> _onCancelEvent(
    CancelEvent event,
    Emitter<EventDetailsState> emit,
  ) async {
    emit(EventOperationInProgress(state));

    try {
      await _eventRepository.cancelEvent(eventId);

      emit(EventOperationSuccess(
        state,
        successMessage: 'Évènement annulé',
      ));
    } catch (e) {
      log('Error while canceling event', error: e);
      emit(EventOperationFailure(
        state,
        errorMessage: 'Impossible d\'annuler l\'évènement',
      ));
    }
  }

  Future<void> _onTerminateUserJourney(
    TerminateUserJourney event,
    Emitter<EventDetailsState> emit,
  ) async {
    emit(EventOperationInProgress(state));

    try {
      await _eventRepository.terminateUserJourney(eventId);

      emit(EventOperationSuccess(
        state,
        successMessage: 'Trajet terminé',
      ));
    } catch (e) {
      log('Error while terminating user journey', error: e);
      emit(EventOperationFailure(
        state,
        errorMessage: 'Impossible de terminer le trajet',
      ));
    }
  }
}
