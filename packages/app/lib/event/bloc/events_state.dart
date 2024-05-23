import 'package:flutter/cupertino.dart';
import 'package:hollybike/event/types/event.dart';
import 'package:hollybike/event/types/minimal_event.dart';

enum EventStatus { loading, success, error, initial }

@immutable
class EventsState {
  final List<MinimalEvent> events;

  final EventStatus status;

  final bool hasMore;
  final int nextPage;

  const EventsState({
    this.events = const [],
    this.hasMore = true,
    this.nextPage = 0,
    this.status = EventStatus.initial,
  });

  EventsState copyWith({
    List<MinimalEvent>? events,
    bool? hasMore,
    int? nextPage,
    Event? createdEvent,
  }) {
    return EventsState(
      events: events ?? this.events,
      hasMore: hasMore ?? this.hasMore,
      nextPage: nextPage ?? this.nextPage,
    );
  }
}

class EventInitial extends EventsState {}

class EventPageLoadInProgress extends EventsState {
  EventPageLoadInProgress(EventsState state)
      : super(
          events: state.events,
          hasMore: state.hasMore,
          nextPage: state.nextPage,
          status: EventStatus.loading,
        );
}

class EventPageLoadSuccess extends EventsState {
  EventPageLoadSuccess(EventsState state)
      : super(
          events: state.events,
          hasMore: state.hasMore,
          nextPage: state.nextPage,
          status: EventStatus.success,
        );
}

class EventPageLoadFailure extends EventsState {
  final String errorMessage;

  EventPageLoadFailure(EventsState state, {required this.errorMessage})
      : super(
          events: state.events,
          hasMore: state.hasMore,
          nextPage: state.nextPage,
          status: EventStatus.error,
        );
}

class EventCreationInProgress extends EventsState {
  EventCreationInProgress(EventsState state)
      : super(
          events: state.events,
          hasMore: state.hasMore,
          nextPage: state.nextPage,
          status: EventStatus.error,
        );
}

class EventSuccessfullyCreated extends EventsState {
  final Event createdEvent;

  EventSuccessfullyCreated(EventsState state, {required this.createdEvent})
      : super(
          events: state.events,
          hasMore: state.hasMore,
          nextPage: state.nextPage,
          status: EventStatus.error,
        );
}

class EventCreateError extends EventsState {
  final String errorMessage;

  EventCreateError(EventsState state, {required this.errorMessage})
      : super(
          events: state.events,
          hasMore: state.hasMore,
          nextPage: state.nextPage,
          status: EventStatus.error,
        );
}
