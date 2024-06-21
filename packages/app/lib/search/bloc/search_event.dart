import 'package:flutter/material.dart';

import '../../../auth/types/auth_session.dart';

@immutable
abstract class SearchEvent {}

class SubscribeToEventsSearch extends SearchEvent {
  SubscribeToEventsSearch();
}

class LoadEventsSearchNextPage extends SearchEvent {
  final AuthSession session;
  final String query;

  LoadEventsSearchNextPage({required this.session, required this.query});
}

class LoadProfilesSearchNextPage extends SearchEvent {
  final AuthSession session;
  final String query;

  LoadProfilesSearchNextPage({required this.session, required this.query});
}

class RefreshSearch extends SearchEvent {
  final AuthSession session;
  final String query;

  RefreshSearch({required this.session, required this.query});
}
