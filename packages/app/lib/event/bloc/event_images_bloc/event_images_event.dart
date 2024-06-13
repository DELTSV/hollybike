import 'package:flutter/cupertino.dart';

import '../../../auth/types/auth_session.dart';

@immutable
abstract class EventImagesEvent {}

class LoadEventImagesNextPage extends EventImagesEvent {
  final int eventId;
  final AuthSession session;

  LoadEventImagesNextPage({
    required this.session,
    required this.eventId,
  });
}

class RefreshEventImages extends EventImagesEvent {
  final int eventId;
  final AuthSession session;

  RefreshEventImages({
    required this.session,
    required this.eventId,
  });
}