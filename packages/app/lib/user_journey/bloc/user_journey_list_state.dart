import 'package:flutter/cupertino.dart';
import 'package:hollybike/user_journey/type/user_journey.dart';

enum UserJourneyListStatus { loading, success, error, initial }

@immutable
class UserJourneyListState {
  final List<UserJourney> userJourneys;

  final bool hasMore;
  final int nextPage;

  final UserJourneyListStatus status;

  const UserJourneyListState({
    this.userJourneys = const [],
    this.hasMore = true,
    this.nextPage = 0,
    this.status = UserJourneyListStatus.initial,
  });

  UserJourneyListState.state(UserJourneyListState state)
      : this(
          userJourneys: state.userJourneys,
          hasMore: state.hasMore,
          nextPage: state.nextPage,
          status: state.status,
        );

  UserJourneyListState copyWith({
    UserJourneyListStatus? status,
    List<UserJourney>? userJourneys,
    bool? hasMore,
    int? nextPage,
  }) {
    return UserJourneyListState(
      status: status ?? this.status,
      userJourneys: userJourneys ?? this.userJourneys,
      hasMore: hasMore ?? this.hasMore,
      nextPage: nextPage ?? this.nextPage,
    );
  }
}

class UserJourneyListInitial extends UserJourneyListState {}

class UserJourneyListPageLoadInProgress extends UserJourneyListState {
  UserJourneyListPageLoadInProgress(UserJourneyListState state)
      : super.state(state.copyWith(status: UserJourneyListStatus.loading));
}

class UserJourneyListPageLoadSuccess extends UserJourneyListState {
  UserJourneyListPageLoadSuccess(UserJourneyListState state)
      : super.state(state.copyWith(status: UserJourneyListStatus.success));
}

class UserJourneyListPageLoadFailure extends UserJourneyListState {
  final String errorMessage;

  UserJourneyListPageLoadFailure(UserJourneyListState state,
      {required this.errorMessage})
      : super.state(state.copyWith(status: UserJourneyListStatus.error));
}
