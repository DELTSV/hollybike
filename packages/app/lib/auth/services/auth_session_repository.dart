/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:async';

import 'package:hollybike/auth/types/auth_session.dart';
import 'package:rxdart/rxdart.dart';

class AuthSessionRepository {
  final Subject<AuthSession?> _authSessionChangeStream = BehaviorSubject();

  Stream<AuthSession?> get authSessionStream => _authSessionChangeStream.stream;

  set authSessionState(AuthSession? session) =>
      _authSessionChangeStream.add(session);
}
