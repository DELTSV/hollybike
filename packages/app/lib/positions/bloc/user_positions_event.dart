import 'package:flutter/foundation.dart';

import '../../auth/types/auth_session.dart';

@immutable
abstract class UserPositionsEvent {}

class SubscribeToUserPositions extends UserPositionsEvent {
  final int eventId;
  final AuthSession session;

  SubscribeToUserPositions({
    required this.eventId,
    required this.session,
  });
}
