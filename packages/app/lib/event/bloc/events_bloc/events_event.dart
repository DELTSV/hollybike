import 'package:flutter/material.dart';

import '../../types/event_form_data.dart';

@immutable
abstract class EventsEvent {}

class SubscribeToEvents extends EventsEvent {
  SubscribeToEvents();
}

class LoadEventsNextPage extends EventsEvent {
  LoadEventsNextPage();
}

class RefreshEvents extends EventsEvent {
  RefreshEvents();
}

class RefreshUserEvents extends EventsEvent {
  final int userId;

  RefreshUserEvents({
    required this.userId,
  });
}

class CreateEvent extends EventsEvent {
  final EventFormData formData;

  CreateEvent({
    required this.formData,
  });
}
