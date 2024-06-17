import 'package:flutter/material.dart';
import 'package:hollybike/journey/type/journey.dart';

import '../../../auth/types/auth_session.dart';
import '../../types/event_form_data.dart';

@immutable
abstract class EventDetailsEvent {}

class SubscribeToEvent extends EventDetailsEvent {
  SubscribeToEvent();
}

class LoadEventDetails extends EventDetailsEvent {
  final AuthSession session;
  final int eventId;

  LoadEventDetails({required this.session, required this.eventId});
}

class PublishEvent extends EventDetailsEvent {
  final AuthSession session;
  final int eventId;

  PublishEvent({required this.session, required this.eventId});
}

class GetEventParticipationsPreviewData extends EventDetailsEvent {
  final AuthSession session;
  final int eventId;

  GetEventParticipationsPreviewData({
    required this.session,
    required this.eventId,
  });
}

class JoinEvent extends EventDetailsEvent {
  final AuthSession session;
  final int eventId;

  JoinEvent({required this.session, required this.eventId});
}

class LeaveEvent extends EventDetailsEvent {
  final AuthSession session;
  final int eventId;

  LeaveEvent({required this.session, required this.eventId});
}

class CancelEvent extends EventDetailsEvent {
  final AuthSession session;
  final int eventId;

  CancelEvent({required this.session, required this.eventId});
}

class DeleteEvent extends EventDetailsEvent {
  final AuthSession session;
  final int eventId;

  DeleteEvent({required this.session, required this.eventId});
}

class EditEvent extends EventDetailsEvent {
  final AuthSession session;
  final int eventId;
  final EventFormData formData;

  EditEvent({
    required this.session,
    required this.eventId,
    required this.formData,
  });
}

class AttachJourneyToEvent extends EventDetailsEvent {
  final AuthSession session;
  final int eventId;
  final Journey journey;

  AttachJourneyToEvent({
    required this.session,
    required this.eventId,
    required this.journey,
  });
}