import 'package:flutter/cupertino.dart';

enum UserJourneyDetailsStatus { loading, success, error, initial }

@immutable
class UserJourneyDetailsState {
  final UserJourneyDetailsStatus status;

  const UserJourneyDetailsState({
    this.status = UserJourneyDetailsStatus.initial,
  });

  UserJourneyDetailsState.state(UserJourneyDetailsState state)
      : this(
          status: state.status,
        );

  UserJourneyDetailsState copyWith({
    UserJourneyDetailsStatus? status,
  }) {
    return UserJourneyDetailsState(
      status: status ?? this.status,
    );
  }
}

class UserJourneyDetailsInitial extends UserJourneyDetailsState {}

class UserJourneyOperationInProgress extends UserJourneyDetailsState {
  UserJourneyOperationInProgress(UserJourneyDetailsState state)
      : super.state(state.copyWith(status: UserJourneyDetailsStatus.loading));
}

class UserJourneyOperationSuccess extends UserJourneyDetailsState {
  UserJourneyOperationSuccess(UserJourneyDetailsState state)
      : super.state(state.copyWith(status: UserJourneyDetailsStatus.success));
}

class UserJourneyOperationFailure extends UserJourneyDetailsState {
  final String errorMessage;

  UserJourneyOperationFailure(UserJourneyDetailsState state,
      {required this.errorMessage})
      : super.state(state.copyWith(status: UserJourneyDetailsStatus.error));
}
