import 'package:flutter/material.dart';

import '../../auth/types/auth_session.dart';

@immutable
abstract class EventsEvent {}

class SubscribeToEvents extends EventsEvent {
  SubscribeToEvents();
}

class LoadEventsNextPage extends EventsEvent {
  final AuthSession session;

  LoadEventsNextPage({required this.session});
}

class RefreshEvents extends EventsEvent {
  final AuthSession session;

  RefreshEvents({required this.session});
}

class CreateEvent extends EventsEvent {
  final AuthSession session;
  final String name;
  final String? description;
  final DateTime startDate;
  final DateTime? endDate;

  CreateEvent({
    required this.session,
    required this.name,
    this.description,
    required this.startDate,
    this.endDate,
  });
}