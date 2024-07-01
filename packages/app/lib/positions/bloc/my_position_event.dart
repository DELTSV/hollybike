import 'package:flutter/cupertino.dart';

@immutable
abstract class MyPositionEvent {}

class EnableSendPosition extends MyPositionEvent {
  final int eventId;
  final String eventName;

  EnableSendPosition({
    required this.eventId,
    required this.eventName,
  });
}

class DisableSendPositions extends MyPositionEvent {
  DisableSendPositions();
}

class SubscribeToMyPositionUpdates extends MyPositionEvent {
  SubscribeToMyPositionUpdates();
}
