import 'package:flutter/material.dart';

import '../../auth/types/auth_session.dart';

@immutable
abstract class EventEvent {}

class LoadEventsNextPage extends EventEvent {
  final AuthSession session;

  LoadEventsNextPage({required this.session});
}

class RefreshEvents extends EventEvent {
  final AuthSession session;

  RefreshEvents({required this.session});
}