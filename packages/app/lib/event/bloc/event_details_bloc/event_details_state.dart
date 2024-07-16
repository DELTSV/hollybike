/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/cupertino.dart';
import 'package:hollybike/event/types/event_details.dart';

import '../../types/participation/event_participation.dart';

enum EventDetailsStatus { loading, success, error, initial }

@immutable
class EventDetailsState {
  final EventDetails? eventDetails;
  final EventDetailsStatus status;

  const EventDetailsState({
    this.status = EventDetailsStatus.initial,
    this.eventDetails,
  });

  EventDetailsState.state(EventDetailsState state)
      : this(
          eventDetails: state.eventDetails,
          status: state.status,
        );

  EventDetailsState copyWith({
    EventDetails? event,
    EventDetailsStatus? status,
    List<EventParticipation>? participants,
    int? remainingParticipants,
  }) {
    return EventDetailsState(
      eventDetails: event ?? eventDetails,
      status: status ?? this.status,
    );
  }
}

class EventDetailsInitial extends EventDetailsState {}

class EventDetailsLoadInProgress extends EventDetailsState {
  EventDetailsLoadInProgress(EventDetailsState state)
      : super.state(state.copyWith(status: EventDetailsStatus.loading));
}

class EventDetailsLoadSuccess extends EventDetailsState {
  EventDetailsLoadSuccess(EventDetailsState state)
      : super.state(state.copyWith(status: EventDetailsStatus.success));
}

class EventDetailsLoadFailure extends EventDetailsState {
  final String errorMessage;

  EventDetailsLoadFailure(EventDetailsState state, {required this.errorMessage})
      : super.state(state.copyWith(status: EventDetailsStatus.error));
}

class EventOperationInProgress extends EventDetailsState {
  EventOperationInProgress(EventDetailsState state)
      : super.state(state.copyWith(status: EventDetailsStatus.loading));
}

class EventOperationSuccess extends EventDetailsState {
  final String successMessage;

  EventOperationSuccess(EventDetailsState state, {required this.successMessage})
      : super.state(state.copyWith(status: EventDetailsStatus.success));
}

class EventOperationFailure extends EventDetailsState {
  final String errorMessage;

  EventOperationFailure(EventDetailsState state, {required this.errorMessage})
      : super.state(state.copyWith(status: EventDetailsStatus.error));
}

class DeleteEventInProgress extends EventDetailsState {
  DeleteEventInProgress(EventDetailsState state)
      : super.state(state.copyWith(status: EventDetailsStatus.loading));
}

class DeleteEventSuccess extends EventDetailsState {
  DeleteEventSuccess(EventDetailsState state)
      : super.state(state.copyWith(status: EventDetailsStatus.success));
}

class UserJourneyReset extends EventDetailsState {
  UserJourneyReset(EventDetailsState state)
      : super.state(state.copyWith(status: EventDetailsStatus.success));
}

class DeleteEventFailure extends EventDetailsState {
  final String errorMessage;

  DeleteEventFailure(EventDetailsState state, {required this.errorMessage})
      : super.state(state.copyWith(status: EventDetailsStatus.error));
}

class LeaveEventSuccess extends EventDetailsState {
  LeaveEventSuccess(EventDetailsState state)
      : super.state(state.copyWith(status: EventDetailsStatus.success));
}
