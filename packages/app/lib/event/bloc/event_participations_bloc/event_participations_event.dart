import 'package:flutter/material.dart';

import '../../../auth/types/auth_session.dart';
import '../../types/event_participation.dart';

@immutable
abstract class EventParticipationsEvent {}

class SubscribeToEventParticipations extends EventParticipationsEvent {
  SubscribeToEventParticipations();
}

class LoadEventParticipationsNextPage extends EventParticipationsEvent {
  final int eventId;
  final AuthSession session;

  LoadEventParticipationsNextPage({
    required this.session,
    required this.eventId,
  });
}

class RefreshEventParticipations extends EventParticipationsEvent {
  final int eventId;
  final List<EventParticipation> participationPreview;
  final AuthSession session;

  RefreshEventParticipations({
    required this.session,
    required this.eventId,
    required this.participationPreview,
  });
}
