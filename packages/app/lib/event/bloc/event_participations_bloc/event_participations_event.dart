import 'package:flutter/material.dart';

import '../../types/participation/event_participation.dart';

@immutable
abstract class EventParticipationsEvent {}

class SubscribeToEventParticipations extends EventParticipationsEvent {
  SubscribeToEventParticipations();
}

class LoadEventParticipationsNextPage extends EventParticipationsEvent {
  LoadEventParticipationsNextPage();
}

class RefreshEventParticipations extends EventParticipationsEvent {
  final List<EventParticipation> participationPreview;

  RefreshEventParticipations({
    required this.participationPreview,
  });
}

class DemoteEventParticipant extends EventParticipationsEvent {
  final int userId;

  DemoteEventParticipant({
    required this.userId,
  });
}

class PromoteEventParticipant extends EventParticipationsEvent {
  final int userId;

  PromoteEventParticipant({
    required this.userId,
  });
}

class RemoveEventParticipant extends EventParticipationsEvent {
  final int userId;

  RemoveEventParticipant({
    required this.userId,
  });
}
