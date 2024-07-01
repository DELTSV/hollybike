import 'package:flutter/foundation.dart';

@immutable
abstract class UserPositionsEvent {}

class SubscribeToUserPositions extends UserPositionsEvent {
  final int eventId;

  SubscribeToUserPositions({
    required this.eventId,
  });
}
