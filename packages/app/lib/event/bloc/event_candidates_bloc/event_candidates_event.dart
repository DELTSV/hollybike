import 'package:flutter/material.dart';

@immutable
abstract class EventCandidatesEvent {}

class SubscribeToEventCandidates extends EventCandidatesEvent {
  SubscribeToEventCandidates();
}

class LoadEventCandidatesNextPage extends EventCandidatesEvent {
  final int eventId;

  LoadEventCandidatesNextPage({
    required this.eventId,
  });
}

class RefreshEventCandidates extends EventCandidatesEvent {
  final int eventId;

  RefreshEventCandidates({
    required this.eventId,
  });
}

class SearchCandidates extends EventCandidatesEvent {
  final int eventId;
  final String search;

  SearchCandidates({
    required this.eventId,
    required this.search,
  });
}

class AddCandidates extends EventCandidatesEvent {
  final int eventId;
  final List<int> userIds;

  AddCandidates({
    required this.eventId,
    required this.userIds,
  });
}
