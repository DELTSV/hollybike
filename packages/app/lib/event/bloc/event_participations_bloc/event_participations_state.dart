/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/cupertino.dart';
import 'package:hollybike/event/types/event.dart';

import '../../types/participation/event_participation.dart';

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

  EventParticipationsState.state(EventParticipationsState state)
      : this(
          participants: state.participants,
          hasMore: state.hasMore,
          nextPage: state.nextPage,
          status: state.status,
        );

  EventParticipationsState copyWith({
    EventParticipationsStatus? status,
    List<EventParticipation>? participants,
    bool? hasMore,
    int? nextPage,
    Event? createdEvent,
  }) {
    return EventParticipationsState(
      status: status ?? this.status,
      participants: participants ?? this.participants,
      hasMore: hasMore ?? this.hasMore,
      nextPage: nextPage ?? this.nextPage,
    );
  }
}

class EventParticipationsInitial extends EventParticipationsState {}

class EventParticipationsPageLoadInProgress extends EventParticipationsState {
  EventParticipationsPageLoadInProgress(EventParticipationsState state)
      : super.state(state.copyWith(status: EventParticipationsStatus.loading));
}

class EventParticipationsPageLoadSuccess extends EventParticipationsState {
  EventParticipationsPageLoadSuccess(EventParticipationsState state)
      : super.state(state.copyWith(status: EventParticipationsStatus.success));
}

class EventParticipationsPageLoadFailure extends EventParticipationsState {
  final String errorMessage;

  EventParticipationsPageLoadFailure(EventParticipationsState state,
      {required this.errorMessage})
      : super.state(state.copyWith(status: EventParticipationsStatus.error));
}

class EventParticipationsOperationInProgress extends EventParticipationsState {
  EventParticipationsOperationInProgress(EventParticipationsState state)
      : super.state(state.copyWith(status: EventParticipationsStatus.loading));
}

class EventParticipationsOperationSuccess extends EventParticipationsState {
  final String successMessage;

  EventParticipationsOperationSuccess(EventParticipationsState state,
      {required this.successMessage})
      : super.state(state.copyWith(status: EventParticipationsStatus.loading));
}

class EventParticipationsOperationFailure extends EventParticipationsState {
  final String errorMessage;

  EventParticipationsOperationFailure(EventParticipationsState state,
      {required this.errorMessage})
      : super.state(state.copyWith(status: EventParticipationsStatus.error));
}

class EventParticipationsDeletionInProgress extends EventParticipationsState {
  EventParticipationsDeletionInProgress(EventParticipationsState state)
      : super.state(state.copyWith(status: EventParticipationsStatus.loading));
}

class EventParticipationsDeleted extends EventParticipationsState {
  EventParticipationsDeleted(EventParticipationsState state)
      : super.state(state.copyWith(status: EventParticipationsStatus.loading));
}

class EventParticipationsDeletionFailure extends EventParticipationsState {
  final String errorMessage;

  EventParticipationsDeletionFailure(EventParticipationsState state,
      {required this.errorMessage})
      : super.state(state.copyWith(status: EventParticipationsStatus.error));
}
