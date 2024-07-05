import 'dart:async';

import 'package:hollybike/auth/types/auth_session.dart';
import 'package:rxdart/rxdart.dart';

class AuthSessionRepository {
  final Subject<AuthSession?> _authSessionChangeStream = BehaviorSubject();

  Stream<AuthSession?> get authSessionStream => _authSessionChangeStream.stream;

  final Subject<AuthSession> _authSessionSwitchStream = BehaviorSubject();

  Stream<AuthSession> get authSessionSwitchStream =>
      _authSessionSwitchStream.stream;

  set authSessionSwitch(AuthSession session) =>
      _authSessionSwitchStream.add(session);

  set authSessionState(AuthSession? session) =>
      _authSessionChangeStream.add(session);
}
