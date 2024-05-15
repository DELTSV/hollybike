import 'package:flutter/material.dart';

import '../../auth/types/auth_session.dart';

@immutable
abstract class EventEvent {}

class LoadEvents extends EventEvent {
  final int page;
  final AuthSession session;

  LoadEvents({required this.page, required this.session});
}
