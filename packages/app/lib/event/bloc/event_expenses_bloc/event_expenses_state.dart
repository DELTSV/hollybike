/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
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

class EventExpensesOperationInProgress extends EventExpensesState {
  EventExpensesOperationInProgress(EventExpensesState state)
      : super.state(state.copyWith(status: EventExpensesStatus.loading));
}

class EventExpensesOperationSuccess extends EventExpensesState {
  final String successMessage;

  EventExpensesOperationSuccess(EventExpensesState state, {required this.successMessage})
      : super.state(state.copyWith(status: EventExpensesStatus.success));
}

class EventExpensesOperationFailure extends EventExpensesState {
  final String errorMessage;

  EventExpensesOperationFailure(EventExpensesState state,
      {required this.errorMessage})
      : super.state(state.copyWith(status: EventExpensesStatus.error));
}
