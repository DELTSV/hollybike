import 'package:flutter/material.dart';

import '../../types/participation/event_participation.dart';

@immutable
abstract class EventParticipationsEvent {}

class SubscribeToEventParticipations extends EventParticipationsEvent {
  SubscribeToEventParticipations();
}

class LoadEventParticipationsNextPage extends EventParticipationsEvent {
  final int eventId;

  LoadEventParticipationsNextPage({
    required this.eventId,
  });
}

class RefreshEventParticipations extends EventParticipationsEvent {
  final int eventId;
  final List<EventParticipation> participationPreview;

  RefreshEventParticipations({
    required this.eventId,
    required this.participationPreview,
  });
}

class DemoteEventParticipant extends EventParticipationsEvent {
  final int eventId;
  final int userId;

  DemoteEventParticipant({
    required this.eventId,
    required this.userId,
  });
}

class PromoteEventParticipant extends EventParticipationsEvent {
  final int eventId;
  final int userId;

  PromoteEventParticipant({
    required this.eventId,
    required this.userId,
  });
}

class RemoveEventParticipant extends EventParticipationsEvent {
  final int eventId;
  final int userId;

  RemoveEventParticipant({
    required this.eventId,
    required this.userId,
  });
}
