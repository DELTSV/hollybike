import 'package:flutter/cupertino.dart';

enum EventJourneyStatus { loading, success, error, initial }

@immutable
class EventJourneyState {
  final EventJourneyStatus status;

  const EventJourneyState({
    this.status = EventJourneyStatus.initial,
  });

  EventJourneyState.state(EventJourneyState state)
      : this(
    status: state.status,
  );

  EventJourneyState copyWith({
    EventJourneyStatus? status,
  }) {
    return EventJourneyState(
      status: status ?? this.status,
    );
  }
}

class EventJourneyInitial extends EventJourneyState {}

class EventJourneyOperationInProgress extends EventJourneyState {
  EventJourneyOperationInProgress(EventJourneyState state)
      : super.state(state.copyWith(status: EventJourneyStatus.loading));
}

class EventJourneyOperationSuccess extends EventJourneyState {
  final String successMessage;

  EventJourneyOperationSuccess(EventJourneyState state, {required this.successMessage})
      : super.state(state.copyWith(status: EventJourneyStatus.success));
}

class EventJourneyUploadInProgress extends EventJourneyState {
  EventJourneyUploadInProgress(EventJourneyState state)
      : super.state(state.copyWith(status: EventJourneyStatus.loading));
}

class EventJourneyUploadSuccess extends EventJourneyState {
  EventJourneyUploadSuccess(EventJourneyState state)
      : super.state(state.copyWith(status: EventJourneyStatus.success));
}

class EventJourneyCreationInProgress extends EventJourneyState {
  EventJourneyCreationInProgress(EventJourneyState state)
      : super.state(state.copyWith(status: EventJourneyStatus.loading));
}

class EventJourneyCreationSuccess extends EventJourneyState {
  EventJourneyCreationSuccess(EventJourneyState state)
      : super.state(state.copyWith(status: EventJourneyStatus.success));
}

class EventJourneyOperationFailure extends EventJourneyState {
  final String errorMessage;

  EventJourneyOperationFailure(EventJourneyState state,
      {required this.errorMessage})
      : super.state(state.copyWith(status: EventJourneyStatus.error));
}

class EventJourneyGetPositionsInProgress extends EventJourneyState {
  EventJourneyGetPositionsInProgress(EventJourneyState state)
      : super.state(state.copyWith(status: EventJourneyStatus.loading));
}

class EventJourneyGetPositionsSuccess extends EventJourneyState {
  EventJourneyGetPositionsSuccess(EventJourneyState state)
      : super.state(state.copyWith(status: EventJourneyStatus.success));
}