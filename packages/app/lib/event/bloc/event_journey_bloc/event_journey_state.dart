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

class EventJourneyCreationInProgress extends EventJourneyState {
  EventJourneyCreationInProgress(EventJourneyState state)
      : super.state(state.copyWith(status: EventJourneyStatus.loading));
}

class EventJourneyCreationSuccess extends EventJourneyState {
  EventJourneyCreationSuccess(EventJourneyState state)
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

class EventJourneyFailure extends EventJourneyState {
  final String errorMessage;

  EventJourneyFailure(EventJourneyState state,
      {required this.errorMessage})
      : super.state(state.copyWith(status: EventJourneyStatus.error));
}