import 'package:background_locator_2/location_dto.dart';
import 'package:flutter/material.dart';

enum MyPositionStatus { loading, success, error, initial }

@immutable
class MyPositionState {
  final LocationDto? lastLocation;
  final bool isRunning;
  final MyPositionStatus status;

  const MyPositionState({
    this.lastLocation,
    this.isRunning = false,
    this.status = MyPositionStatus.initial,
  });

  MyPositionState.state(MyPositionState state)
      : this(
          lastLocation: state.lastLocation,
          isRunning: state.isRunning,
        );

  MyPositionState copyWith({
    MyPositionStatus? status,
    LocationDto? lastLocation,
    bool? isRunning,
  }) {
    return MyPositionState(
      status: status ?? this.status,
      lastLocation: lastLocation ?? this.lastLocation,
      isRunning: isRunning ?? this.isRunning,
    );
  }
}

class MyPositionInitial extends MyPositionState {}

class MyPositionLoading extends MyPositionState {
  MyPositionLoading(state)
      : super.state(
          state.copyWith(status: MyPositionStatus.loading),
        );
}

class MyPositionStarted extends MyPositionState {
  MyPositionStarted(super.state) : super.state();
}

class MyPositionInitialized extends MyPositionState {
  MyPositionInitialized(super.state) : super.state();
}


class MyPositionStopped extends MyPositionState {
  MyPositionStopped(super.state) : super.state();
}

class MyPositionFailure extends MyPositionState {
  final String errorMessage;

  MyPositionFailure(super.state, this.errorMessage) : super.state();
}


class MyPositionUpdated extends MyPositionState {
  MyPositionUpdated(state, LocationDto? lastLocation)
      : super.state(
          MyPositionState(
            lastLocation: lastLocation,
            isRunning: state.isRunning,
            status: state.status,
          ),
        );
}
