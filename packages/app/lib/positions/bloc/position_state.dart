import 'package:background_locator_2/location_dto.dart';
import 'package:flutter/material.dart';

enum PositionStatus { loading, success, error, initial }

@immutable
class PositionState {
  final LocationDto? lastLocation;
  final bool isRunning;
  final PositionStatus status;

  const PositionState({
    this.lastLocation,
    this.isRunning = false,
    this.status = PositionStatus.initial,
  });

  PositionState.state(PositionState state)
      : this(
          lastLocation: state.lastLocation,
          isRunning: state.isRunning,
        );

  PositionState copyWith({
    PositionStatus? status,
    LocationDto? lastLocation,
    bool? isRunning,
  }) {
    return PositionState(
      status: status ?? this.status,
      lastLocation: lastLocation ?? this.lastLocation,
      isRunning: isRunning ?? this.isRunning,
    );
  }
}

class PositionInitial extends PositionState {}

class PositionLoading extends PositionState {
  PositionLoading(state)
      : super.state(
          state.copyWith(status: PositionStatus.loading),
        );
}

class PositionStarted extends PositionState {
  PositionStarted(super.state) : super.state();
}

class PositionInitialized extends PositionState {
  PositionInitialized(super.state) : super.state();
}


class PositionStopped extends PositionState {
  PositionStopped(super.state) : super.state();
}

class PositionFailure extends PositionState {
  final String errorMessage;

  PositionFailure(super.state, this.errorMessage) : super.state();
}


class PositionUpdated extends PositionState {
  PositionUpdated(state, LocationDto? lastLocation)
      : super.state(
          PositionState(
            lastLocation: lastLocation,
            isRunning: state.isRunning,
            status: state.status,
          ),
        );
}
