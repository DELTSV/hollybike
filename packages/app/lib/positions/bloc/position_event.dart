import 'package:flutter/cupertino.dart';

import '../../auth/types/auth_session.dart';

@immutable
abstract class PositionEvent {}

class ListenAndSendUserPosition extends PositionEvent {
  final AuthSession session;

  ListenAndSendUserPosition({
    required this.session,
  });
}

class DisableSendPositions extends PositionEvent {
  DisableSendPositions();
}
