import 'package:flutter/material.dart';

import '../../../auth/types/auth_session.dart';

@immutable
abstract class EventCandidatesEvent {}

class SubscribeToEventCandidates extends EventCandidatesEvent {
  SubscribeToEventCandidates();
}

class LoadEventCandidatesNextPage extends EventCandidatesEvent {
  final int eventId;
  final AuthSession session;

  LoadEventCandidatesNextPage({
    required this.session,
    required this.eventId,
  });
}

class RefreshEventCandidates extends EventCandidatesEvent {
  final int eventId;
  final AuthSession session;

  RefreshEventCandidates({
    required this.session,
    required this.eventId,
  });
}

class SearchCandidates extends EventCandidatesEvent {
  final int eventId;
  final AuthSession session;
  final String search;

  SearchCandidates({
    required this.session,
    required this.eventId,
    required this.search,
  });
}
