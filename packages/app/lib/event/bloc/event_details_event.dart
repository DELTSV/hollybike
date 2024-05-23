import 'package:flutter/material.dart';

import '../../auth/types/auth_session.dart';

@immutable
abstract class EventDetailsEvent {}

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