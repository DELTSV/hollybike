import 'package:flutter/cupertino.dart';
import 'package:hollybike/event/types/event.dart';

enum EventStatus { initial, loading, success, error }

@immutable
abstract class EventState {
  final List<Event> events;
  final EventStatus status;

  const EventState({this.events = const [], this.status = EventStatus.initial});
}

class EventInitial extends EventState {}

class EventLoadInProgress extends EventState {}

class EventLoadSuccess extends EventState {
  const EventLoadSuccess({required super.events}) : super(status: EventStatus.success);
}

class EventLoadFailure extends EventState {
  final String errorMessage;

  const EventLoadFailure({required this.errorMessage}) : super(status: EventStatus.error);
}