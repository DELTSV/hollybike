import 'package:flutter/cupertino.dart';

import '../../auth/types/auth_session.dart';

@immutable
abstract class PositionEvent {}

class EnableSendPosition extends PositionEvent {
  final int eventId;
  final String eventName;
  final AuthSession session;

  EnableSendPosition({
    required this.eventId,
    required this.eventName,
    required this.session,
  });
}

class DisableSendPositions extends PositionEvent {
  DisableSendPositions();
}

class SubscribeToPositionUpdates extends PositionEvent {
  SubscribeToPositionUpdates();
}