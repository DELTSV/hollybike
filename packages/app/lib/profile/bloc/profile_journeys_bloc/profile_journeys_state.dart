import 'package:flutter/cupertino.dart';
import 'package:hollybike/user_journey/type/user_journey.dart';

enum ProfileJourneysStatus { loading, success, error, initial }

@immutable
class ProfileJourneysState {
  final List<UserJourney> userJourneys;

  final bool hasMore;
  final int nextPage;

  final ProfileJourneysStatus status;

  const ProfileJourneysState({
    this.userJourneys = const [],
    this.hasMore = true,
    this.nextPage = 0,
    this.status = ProfileJourneysStatus.initial,
  });

  ProfileJourneysState.state(ProfileJourneysState state)
      : this(
          userJourneys: state.userJourneys,
          hasMore: state.hasMore,
          nextPage: state.nextPage,
          status: state.status,
        );

  ProfileJourneysState copyWith({
    ProfileJourneysStatus? status,
    List<UserJourney>? userJourneys,
    bool? hasMore,
    int? nextPage,
  }) {
    return ProfileJourneysState(
      status: status ?? this.status,
      userJourneys: userJourneys ?? this.userJourneys,
      hasMore: hasMore ?? this.hasMore,
      nextPage: nextPage ?? this.nextPage,
    );
  }
}

class ProfileJourneysInitial extends ProfileJourneysState {}

class ProfileJourneysPageLoadInProgress extends ProfileJourneysState {
  ProfileJourneysPageLoadInProgress(ProfileJourneysState state)
      : super.state(state.copyWith(status: ProfileJourneysStatus.loading));
}

class ProfileJourneysPageLoadSuccess extends ProfileJourneysState {
  ProfileJourneysPageLoadSuccess(ProfileJourneysState state)
      : super.state(state.copyWith(status: ProfileJourneysStatus.success));
}

class ProfileJourneysPageLoadFailure extends ProfileJourneysState {
  final String errorMessage;

  ProfileJourneysPageLoadFailure(ProfileJourneysState state,
      {required this.errorMessage})
      : super.state(state.copyWith(status: ProfileJourneysStatus.error));
}
