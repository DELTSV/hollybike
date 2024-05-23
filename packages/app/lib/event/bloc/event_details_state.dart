import 'package:flutter/cupertino.dart';
import 'package:hollybike/event/types/event.dart';

enum EventDetailsStatus { loading, success, error, initial }

@immutable
class EventDetailsState {
  final Event? event;
  final EventDetailsStatus status;

  const EventDetailsState({
    this.status = EventDetailsStatus.initial,
    this.event,
  });

  EventDetailsState copyWith({
    Event? event,
    EventDetailsStatus? status,
  }) {
    return EventDetailsState(
      event: event ?? this.event,
      status: status ?? this.status,
    );
  }
}

class EventDetailsInitial extends EventDetailsState {}

class EventDetailsLoadInProgress extends EventDetailsState {
  EventDetailsLoadInProgress(EventDetailsState state)
      : super(
          event: state.event,
          status: EventDetailsStatus.loading,
        );
}

class EventDetailsLoadSuccess extends EventDetailsState {
  EventDetailsLoadSuccess(EventDetailsState state)
      : super(
          event: state.event,
          status: EventDetailsStatus.success,
        );
}

class EventDetailsLoadFailure extends EventDetailsState {
  final String errorMessage;

  EventDetailsLoadFailure(EventDetailsState state, {required this.errorMessage})
      : super(
          event: state.event,
          status: EventDetailsStatus.error,
        );
}

class EventOperationInProgress extends EventDetailsState {
  EventOperationInProgress(EventDetailsState state)
      : super(
          event: state.event,
          status: EventDetailsStatus.loading,
        );
}

class EventOperationSuccess extends EventDetailsState {
  EventOperationSuccess(EventDetailsState state)
      : super(
          event: state.event,
          status: EventDetailsStatus.success,
        );
}

class EventOperationFailure extends EventDetailsState {
  final String errorMessage;

  EventOperationFailure(EventDetailsState state, {required this.errorMessage})
      : super(
          event: state.event,
          status: EventDetailsStatus.error,
        );
}
