import 'package:flutter/cupertino.dart';
import 'package:hollybike/event/types/event.dart';
import 'package:hollybike/event/types/event_participation.dart';

enum EventParticipationsStatus { loading, success, error, initial }

@immutable
class EventParticipationsState {
  final List<EventParticipation> participants;

  final bool hasMore;
  final int nextPage;

  final EventParticipationsStatus status;

  const EventParticipationsState({
    this.participants = const [],
    this.hasMore = true,
    this.nextPage = 0,
    this.status = EventParticipationsStatus.initial,
  });

  EventParticipationsState copyWith({
    List<EventParticipation>? participants,
    bool? hasMore,
    int? nextPage,
    Event? createdEvent,
  }) {
    return EventParticipationsState(
      participants: participants ?? this.participants,
      hasMore: hasMore ?? this.hasMore,
      nextPage: nextPage ?? this.nextPage,
    );
  }
}

class EventParticipationsInitial extends EventParticipationsState {}

class EventParticipationsPageLoadInProgress extends EventParticipationsState {
  EventParticipationsPageLoadInProgress(EventParticipationsState state)
      : super(
          participants: state.participants,
          hasMore: state.hasMore,
          nextPage: state.nextPage,
          status: EventParticipationsStatus.loading,
        );
}

class EventParticipationsPageLoadSuccess extends EventParticipationsState {
  EventParticipationsPageLoadSuccess(EventParticipationsState state)
      : super(
          participants: state.participants,
          hasMore: state.hasMore,
          nextPage: state.nextPage,
          status: EventParticipationsStatus.success,
        );
}

class EventParticipationsPageLoadFailure extends EventParticipationsState {
  final String errorMessage;

  EventParticipationsPageLoadFailure(EventParticipationsState state,
      {required this.errorMessage})
      : super(
          participants: state.participants,
          hasMore: state.hasMore,
          nextPage: state.nextPage,
          status: EventParticipationsStatus.error,
        );
}
