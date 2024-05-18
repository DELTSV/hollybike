import 'package:flutter/cupertino.dart';
import 'package:hollybike/event/types/event.dart';

enum EventStatus { initial, loading, success, error }

@immutable
class EventState {
  final List<Event> events;
  final EventStatus status;

  final bool hasMore;
  final int nextPage;

  const EventState({
    this.events = const [],
    this.status = EventStatus.initial,
    this.hasMore = true,
    this.nextPage = 0,
  });

  EventState copyWith({
    List<Event>? events,
    EventStatus? status,
    bool? hasMore,
    int? nextPage,
  }) {
    return EventState(
      events: events ?? this.events,
      status: status ?? this.status,
      hasMore: hasMore ?? this.hasMore,
      nextPage: nextPage ?? this.nextPage,
    );
  }

  EventInitial get initial => EventInitial();

  EventLoadInProgress get loadInProgress => EventLoadInProgress(
        events: events,
        hasMore: hasMore,
        nextPage: nextPage,
      );

  EventLoadSuccess get loadSuccess => EventLoadSuccess(
        events: events,
        hasMore: hasMore,
        nextPage: nextPage,
      );

  EventLoadFailure error(String errorMessage) => EventLoadFailure(
        errorMessage: errorMessage,
        events: events,
        hasMore: hasMore,
        nextPage: nextPage,
      );
}

class EventInitial extends EventState {}

class EventLoadInProgress extends EventState {
  const EventLoadInProgress({
    required super.events,
    required super.hasMore,
    required super.nextPage,
  }) : super(status: EventStatus.loading);
}

class EventLoadSuccess extends EventState {
  const EventLoadSuccess({
    required super.events,
    required super.hasMore,
    required super.nextPage,
  }) : super(status: EventStatus.success);
}

class EventLoadFailure extends EventState {
  final String errorMessage;

  const EventLoadFailure(
      {required this.errorMessage,
      required List<Event> events,
      required bool hasMore,
      required int nextPage})
      : super(status: EventStatus.error);
}
