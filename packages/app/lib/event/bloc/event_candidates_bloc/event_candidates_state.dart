import 'package:flutter/cupertino.dart';
import 'package:hollybike/event/types/event.dart';
import 'package:hollybike/event/types/event_candidate.dart';

enum EventCandidatesStatus { loading, success, error, initial }

@immutable
class EventCandidatesState {
  final List<EventCandidate> candidates;

  final String search;

  final bool hasMore;
  final int nextPage;

  final EventCandidatesStatus status;

  const EventCandidatesState({
    this.candidates = const [],
    this.search = "",
    this.hasMore = true,
    this.nextPage = 0,
    this.status = EventCandidatesStatus.initial,
  });

  EventCandidatesState.state(EventCandidatesState state)
      : this(
          candidates: state.candidates,
          search: state.search,
          hasMore: state.hasMore,
          nextPage: state.nextPage,
          status: state.status,
        );

  EventCandidatesState copyWith({
    EventCandidatesStatus? status,
    List<EventCandidate>? candidates,
    String? search,
    bool? hasMore,
    int? nextPage,
    Event? createdEvent,
  }) {
    return EventCandidatesState(
      candidates: candidates ?? this.candidates,
      search: search ?? this.search,
      hasMore: hasMore ?? this.hasMore,
      nextPage: nextPage ?? this.nextPage,
    );
  }
}

class EventCandidatesInitial extends EventCandidatesState {}

class EventCandidatesPageLoadInProgress extends EventCandidatesState {
  EventCandidatesPageLoadInProgress(EventCandidatesState state)
      : super.state(state.copyWith(status: EventCandidatesStatus.loading));
}

class EventCandidatesPageLoadSuccess extends EventCandidatesState {
  EventCandidatesPageLoadSuccess(EventCandidatesState state)
      : super.state(state.copyWith(status: EventCandidatesStatus.success));
}

class EventCandidatesPageLoadFailure extends EventCandidatesState {
  final String errorMessage;

  EventCandidatesPageLoadFailure(EventCandidatesState state,
      {required this.errorMessage})
      : super.state(state.copyWith(status: EventCandidatesStatus.error));
}