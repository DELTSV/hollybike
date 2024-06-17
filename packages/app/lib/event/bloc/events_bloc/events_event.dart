import 'package:flutter/material.dart';

import '../../../auth/types/auth_session.dart';
import '../../types/event_form_data.dart';

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

class RefreshUserEvents extends EventsEvent {
  final AuthSession session;
  final int userId;

  RefreshUserEvents({
    required this.session,
    required this.userId,
  });
}

class CreateEvent extends EventsEvent {
  final AuthSession session;
  final EventFormData formData;

  CreateEvent({
    required this.session,
    required this.formData,
  });
}
