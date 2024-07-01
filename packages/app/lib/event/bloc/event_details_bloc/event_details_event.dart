import 'package:flutter/material.dart';

import '../../types/event_form_data.dart';

@immutable
abstract class EventDetailsEvent {}

class SubscribeToEvent extends EventDetailsEvent {
  SubscribeToEvent();
}

class LoadEventDetails extends EventDetailsEvent {
  final int eventId;

  LoadEventDetails({required this.eventId});
}

class PublishEvent extends EventDetailsEvent {
  final int eventId;

  PublishEvent({required this.eventId});
}

class GetEventParticipationsPreviewData extends EventDetailsEvent {
  final int eventId;

  GetEventParticipationsPreviewData({
    required this.eventId,
  });
}

class JoinEvent extends EventDetailsEvent {
  final int eventId;

  JoinEvent({required this.eventId});
}

class LeaveEvent extends EventDetailsEvent {
  final int eventId;

  LeaveEvent({required this.eventId});
}

class CancelEvent extends EventDetailsEvent {
  final int eventId;

  CancelEvent({required this.eventId});
}

class DeleteEvent extends EventDetailsEvent {
  final int eventId;

  DeleteEvent({required this.eventId});
}

class EditEvent extends EventDetailsEvent {
  final int eventId;
  final EventFormData formData;

  EditEvent({
    required this.eventId,
    required this.formData,
  });
}

class TerminateUserJourney extends EventDetailsEvent {
  final int eventId;

  TerminateUserJourney({
    required this.eventId,
  });
}