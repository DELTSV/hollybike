import 'package:flutter/material.dart';

import '../../auth/types/auth_session.dart';

@immutable
abstract class EventEvent {}

class LoadEventsNextPage extends EventEvent {
  final AuthSession session;

  LoadEventsNextPage({required this.session});
}

class RefreshEvents extends EventEvent {
  final AuthSession session;

  RefreshEvents({required this.session});
}

class LoadEventDetails extends EventEvent {
  final AuthSession session;
  final int eventId;

  LoadEventDetails({required this.session, required this.eventId});
}

class CreateEvent extends EventEvent {
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