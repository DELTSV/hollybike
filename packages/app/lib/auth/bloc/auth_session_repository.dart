import 'dart:async';

import 'package:hollybike/auth/bloc/auth_bloc.dart';

class AuthSessionRepository {
  final StreamController<AuthState> _authSessionChangeStream =
      StreamController();

  Stream<AuthState> get authSessionStream => _authSessionChangeStream.stream;

  set authSessionState(AuthState session) =>
      _authSessionChangeStream.add(session);
}
