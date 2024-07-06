import 'package:flutter/cupertino.dart';
import 'package:hollybike/shared/websocket/recieve/websocket_receive_position.dart';


enum UserPositionsStatus { loading, success, error, initial }

@immutable
class UserPositionsState {
  final List<WebsocketReceivePosition> userPositions;
  final UserPositionsStatus status;

  const UserPositionsState({
    this.userPositions = const [],
    this.status = UserPositionsStatus.initial,
  });

  UserPositionsState.state(UserPositionsState state)
      : this(
          userPositions: state.userPositions,
          status: state.status,
        );

  UserPositionsState copyWith({
    UserPositionsStatus? status,
    List<WebsocketReceivePosition>? userPositions,
  }) {
    return UserPositionsState(
      status: status ?? this.status,
      userPositions: userPositions ?? this.userPositions,
    );
  }
}

class UserPositionsInitial extends UserPositionsState {}

class UserPositionsLoading extends UserPositionsState {
  UserPositionsLoading(state)
      : super.state(
          state.copyWith(status: UserPositionsStatus.loading),
        );
}

class UserPositionsInitialized extends UserPositionsState {
  UserPositionsInitialized(state)
      : super.state(
          state.copyWith(status: UserPositionsStatus.success),
        );
}

class UserPositionsUpdated extends UserPositionsState {
  UserPositionsUpdated(state, List<WebsocketReceivePosition> userPositions)
      : super.state(
          state.copyWith(
            status: UserPositionsStatus.success,
            userPositions: userPositions,
          ),
        );
}

class UserPositionsError extends UserPositionsState {
  final String message;

  UserPositionsError(state, this.message)
      : super.state(
          state.copyWith(status: UserPositionsStatus.error),
        );
}
