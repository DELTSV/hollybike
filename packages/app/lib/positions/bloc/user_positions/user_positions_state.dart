import 'package:flutter/cupertino.dart';
import 'package:hollybike/auth/types/auth_session.dart';
import 'package:hollybike/shared/websocket/recieve/websocket_receive_position.dart';

import 'user_positions_bloc.dart';

enum UserPositionsStatus { loading, success, error, initial }

@immutable
class UserPositionsState {
  final List<WebsocketReceivePosition> userPositions;
  final List<UserLoadEvent> usersLoadEvent;
  final UserPositionsStatus status;
  final AuthSession? currentSession;

  const UserPositionsState({
    this.userPositions = const [],
    this.usersLoadEvent = const [],
    this.status = UserPositionsStatus.initial,
    this.currentSession,
  });

  UserPositionsState.state(UserPositionsState state)
      : this(
          userPositions: state.userPositions,
          usersLoadEvent: state.usersLoadEvent,
          status: state.status,
        );

  UserPositionsState copyWith({
    UserPositionsStatus? status,
    List<UserLoadEvent>? usersLoadEvent,
    List<WebsocketReceivePosition>? userPositions,
  }) {
    return UserPositionsState(
      status: status ?? this.status,
      usersLoadEvent: usersLoadEvent ?? this.usersLoadEvent,
      userPositions: userPositions ?? this.userPositions,
      currentSession: currentSession,
    );
  }

  UserLoadEvent? getPositionUser(WebsocketReceivePosition position) {
    try {
      return usersLoadEvent.firstWhere((user) => user.id == position.userId);
    } catch (_) {
      return null;
    }
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

class UserProfilesUpdated extends UserPositionsState {
  UserProfilesUpdated(
    UserPositionsState oldState,
    UserLoadEvent userLoadEvent,
  ) : super.state(
          oldState.copyWith(
            usersLoadEvent: oldState.usersLoadEvent.copyUpdated(userLoadEvent),
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
