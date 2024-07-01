import 'package:flutter/cupertino.dart';
import 'package:hollybike/event/types/minimal_event.dart';
import 'package:hollybike/user/types/minimal_user.dart';

enum SearchStatus { loading, success, error, initial }

@immutable
class SearchState {
  final String? lastSearchQuery;

  final List<MinimalEvent> events;
  final bool hasMoreEvents;
  final int eventsNextPage;

  final List<MinimalUser> profiles;
  final bool hasMoreProfiles;
  final int profilesNextPage;

  final SearchStatus status;

  const SearchState({
    this.lastSearchQuery,
    this.events = const [],
    this.hasMoreEvents = true,
    this.eventsNextPage = 0,
    this.profiles = const [],
    this.hasMoreProfiles = true,
    this.profilesNextPage = 0,
    this.status = SearchStatus.initial,
  });

  SearchState copyWith({
    String? lastSearchQuery,
    List<MinimalEvent>? events,
    List<MinimalUser>? profiles,
    bool? hasMoreEvents,
    int? eventsNextPage,
    bool? hasMoreProfiles,
    int? profilesNextPage,
    SearchStatus? status,
  }) {
    return SearchState(
      lastSearchQuery: lastSearchQuery ?? this.lastSearchQuery,
      events: events ?? this.events,
      profiles: profiles ?? this.profiles,
      hasMoreEvents: hasMoreEvents ?? this.hasMoreEvents,
      eventsNextPage: eventsNextPage ?? this.eventsNextPage,
      hasMoreProfiles: hasMoreProfiles ?? this.hasMoreProfiles,
      profilesNextPage: profilesNextPage ?? this.profilesNextPage,
      status: status ?? this.status,
    );
  }
}

class SearchInitial extends SearchState {}

class SearchLoadInProgress extends SearchState {
  SearchLoadInProgress(SearchState state)
      : super(
          lastSearchQuery: state.lastSearchQuery,
          events: state.events,
          hasMoreEvents: state.hasMoreEvents,
          eventsNextPage: state.eventsNextPage,
          profiles: state.profiles,
          hasMoreProfiles: state.hasMoreProfiles,
          profilesNextPage: state.profilesNextPage,
          status: SearchStatus.loading,
        );
}

class SearchLoadSuccess extends SearchState {
  SearchLoadSuccess(SearchState state)
      : super(
          lastSearchQuery: state.lastSearchQuery,
          events: state.events,
          hasMoreEvents: state.hasMoreEvents,
          eventsNextPage: state.eventsNextPage,
          profiles: state.profiles,
          hasMoreProfiles: state.hasMoreProfiles,
          profilesNextPage: state.profilesNextPage,
          status: SearchStatus.success,
        );
}

class SearchLoadFailure extends SearchState {
  final String errorMessage;

  SearchLoadFailure(SearchState state, {required this.errorMessage})
      : super(
          lastSearchQuery: state.lastSearchQuery,
          events: state.events,
          hasMoreEvents: state.hasMoreEvents,
          eventsNextPage: state.eventsNextPage,
          profiles: state.profiles,
          hasMoreProfiles: state.hasMoreProfiles,
          profilesNextPage: state.profilesNextPage,
          status: SearchStatus.error,
        );
}
