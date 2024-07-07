import 'package:flutter/cupertino.dart';

enum EventExpensesStatus { loading, success, error, initial }

@immutable
class EventExpensesState {
  final EventExpensesStatus status;

  const EventExpensesState({
    this.status = EventExpensesStatus.initial,
  });

  EventExpensesState.state(EventExpensesState state)
      : this(
          status: state.status,
        );

  EventExpensesState copyWith({
    EventExpensesStatus? status,
  }) {
    return EventExpensesState(
      status: status ?? this.status,
    );
  }
}

class EventJourneyInitial extends EventExpensesState {}

class EventJourneyOperationInProgress extends EventExpensesState {
  EventJourneyOperationInProgress(EventExpensesState state)
      : super.state(state.copyWith(status: EventExpensesStatus.loading));
}

class EventJourneyOperationSuccess extends EventExpensesState {
  final String successMessage;

  EventJourneyOperationSuccess(EventExpensesState state, {required this.successMessage})
      : super.state(state.copyWith(status: EventExpensesStatus.success));
}

class EventJourneyOperationFailure extends EventExpensesState {
  final String errorMessage;

  EventJourneyOperationFailure(EventExpensesState state,
      {required this.errorMessage})
      : super.state(state.copyWith(status: EventExpensesStatus.error));
}
