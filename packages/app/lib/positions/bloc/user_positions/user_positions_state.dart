/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/cupertino.dart';
import 'package:hollybike/shared/websocket/recieve/websocket_receive_position.dart';

import 'user_positions_bloc.dart';

enum UserPositionsStatus { loading, success, error, initial }

@immutable
class UserPositionsState {
  final List<WebsocketReceivePosition> userPositions;
  final List<UserLoadEvent> usersLoadEvent;
  final List<UserPictureLoadEvent> usersPicturesLoadEvent;
  final UserPositionsStatus status;

  const UserPositionsState({
    this.userPositions = const [],
    this.usersLoadEvent = const [],
    this.usersPicturesLoadEvent = const [],
    this.status = UserPositionsStatus.initial,
  });

  UserPositionsState.state(UserPositionsState state)
      : this(
          userPositions: state.userPositions,
          usersLoadEvent: state.usersLoadEvent,
          usersPicturesLoadEvent: state.usersPicturesLoadEvent,
          status: state.status,
        );

  UserPositionsState copyWith({
    UserPositionsStatus? status,
    List<UserLoadEvent>? usersLoadEvent,
    List<UserPictureLoadEvent>? usersPicturesLoadEvent,
    List<WebsocketReceivePosition>? userPositions,
  }) {
    return UserPositionsState(
      status: status ?? this.status,
      userPositions: userPositions ?? this.userPositions,
      usersLoadEvent: usersLoadEvent ?? this.usersLoadEvent,
      usersPicturesLoadEvent:
          usersPicturesLoadEvent ?? this.usersPicturesLoadEvent,
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

class UserPicturesUpdated extends UserPositionsState {
  UserPicturesUpdated(
    UserPositionsState oldState,
    UserPictureLoadEvent userPictureLoadEvent,
  ) : super.state(
          oldState.copyWith(
            usersPicturesLoadEvent: oldState.usersPicturesLoadEvent
                .copyUpdated(userPictureLoadEvent),
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
