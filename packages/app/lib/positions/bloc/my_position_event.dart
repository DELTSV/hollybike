import 'package:flutter/cupertino.dart';

import '../../auth/types/auth_session.dart';

@immutable
abstract class MyPositionEvent {}

class EnableSendPosition extends MyPositionEvent {
  final int eventId;
  final String eventName;
  final AuthSession session;

  EnableSendPosition({
    required this.eventId,
    required this.eventName,
    required this.session,
  });
}

class DisableSendPositions extends MyPositionEvent {
  DisableSendPositions();
}

class SubscribeToMyPositionUpdates extends MyPositionEvent {
  SubscribeToMyPositionUpdates();
}
