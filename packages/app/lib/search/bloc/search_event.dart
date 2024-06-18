import 'package:flutter/material.dart';

import '../../../auth/types/auth_session.dart';

@immutable
abstract class SearchEvent {}

class LoadSearchNextPage extends SearchEvent {
  final AuthSession session;
  final String query;

  LoadSearchNextPage({required this.session, required this.query});
}

class RefreshSearch extends SearchEvent {
  final AuthSession session;
  final String query;

  RefreshSearch({required this.session, required this.query});
}
