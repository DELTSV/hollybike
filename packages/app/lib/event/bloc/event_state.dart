import 'package:flutter/cupertino.dart';
import 'package:hollybike/event/types/event.dart';
import 'package:hollybike/event/types/minimal_event.dart';

enum EventStatus { initial, loading, success, error }

@immutable
class EventState {
  final List<MinimalEvent> events;
  final EventStatus status;

  final bool hasMore;
  final int nextPage;

  final Event? event;

  const EventState({
    this.events = const [],
    this.status = EventStatus.initial,
    this.hasMore = true,
    this.nextPage = 0,
    this.event,
  });

  EventState copyWith({
    List<MinimalEvent>? events,
    EventStatus? status,
    bool? hasMore,
    int? nextPage,
    Event? event,
  }) {
    return EventState(
      events: events ?? this.events,
      status: status ?? this.status,
      hasMore: hasMore ?? this.hasMore,
      nextPage: nextPage ?? this.nextPage,
      event: event ?? this.event,
    );
  }

  EventInitial get initial => EventInitial();

  EventLoadInProgress get loadInProgress => EventLoadInProgress(
        events: events,
        hasMore: hasMore,
        nextPage: nextPage,
        event: event,
      );

  EventLoadSuccess get loadSuccess => EventLoadSuccess(
        events: events,
        hasMore: hasMore,
        nextPage: nextPage,
        event: event,
      );

  EventLoadFailure error(String errorMessage) => EventLoadFailure(
        errorMessage: errorMessage,
        events: events,
        hasMore: hasMore,
        nextPage: nextPage,
        event: event,
      );
}

class EventInitial extends EventState {}

class EventLoadInProgress extends EventState {
  const EventLoadInProgress({
    required super.events,
    required super.hasMore,
    required super.nextPage,
    required super.event,
  }) : super(status: EventStatus.loading);
}

class EventLoadSuccess extends EventState {
  const EventLoadSuccess({
    required super.events,
    required super.hasMore,
    required super.nextPage,
    required super.event,
  }) : super(status: EventStatus.success);
}

class EventLoadFailure extends EventState {
  final String errorMessage;

  const EventLoadFailure({
    required this.errorMessage,
    required List<MinimalEvent> events,
    required bool hasMore,
    required int nextPage,
    required super.event,
  }) : super(status: EventStatus.error);
}
