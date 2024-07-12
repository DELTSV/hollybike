import 'package:flutter/material.dart';

import '../../types/event_form_data.dart';

@immutable
abstract class EventDetailsEvent {}

class SubscribeToEvent extends EventDetailsEvent {
  SubscribeToEvent();
}

class LoadEventDetails extends EventDetailsEvent {
  LoadEventDetails();
}

class PublishEvent extends EventDetailsEvent {
  PublishEvent();
}

class GetEventParticipationsPreviewData extends EventDetailsEvent {
  GetEventParticipationsPreviewData();
}

class JoinEvent extends EventDetailsEvent {
  JoinEvent();
}

class LeaveEvent extends EventDetailsEvent {
  LeaveEvent();
}

class CancelEvent extends EventDetailsEvent {
  CancelEvent();
}

class DeleteEvent extends EventDetailsEvent {
  DeleteEvent();
}

class EditEvent extends EventDetailsEvent {
  final EventFormData formData;

  EditEvent({
    required this.formData,
  });
}

class TerminateUserJourney extends EventDetailsEvent {
  TerminateUserJourney();
}

class ResetUserJourney extends EventDetailsEvent {
  ResetUserJourney();
}

class EventStarted extends EventDetailsEvent {
  EventStarted();
}
