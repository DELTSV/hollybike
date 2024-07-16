/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:async';

import 'package:hollybike/auth/services/auth_api.dart';
import 'package:hollybike/auth/services/auth_persistence.dart';
import 'package:hollybike/auth/types/auth_session.dart';
import 'package:hollybike/auth/types/login_dto.dart';
import 'package:hollybike/auth/types/signup_dto.dart';
import 'package:rxdart/rxdart.dart';

class AuthRepository {
  final AuthApi _authApi;
  final AuthPersistence _authPersistence;

  final BehaviorSubject<AuthSession?> _connectedSession = BehaviorSubject();

  get connectedStream => _connectedSession.stream;

  AuthRepository({
    required AuthApi authApi,
    required AuthPersistence authPersistence,
  })  : _authPersistence = authPersistence,
        _authApi = authApi;

  set connected(AuthSession? session) => _connectedSession.add(session);

  Future<List<AuthSession>> retrievePersistedSessions() async {
    return await _authPersistence.sessions;
  }

  void persistSessions(List<AuthSession> sessions) {
    _authPersistence.sessions = sessions;
  }

  FutureOr<AuthSession?> get currentSession async =>
      await _authPersistence.currentSession;

  set currentSession(FutureOr<AuthSession?> session) =>
      _authPersistence.currentSession = session;

  Future<AuthSession> login(String host, LoginDto dto) {
    return _authApi.login(host, dto);
  }

  Future<AuthSession> signup(String host, SignupDto dto) {
    return _authApi.signup(host, dto);
  }

  Future<void> removeSession(AuthSession session) {
    return _authPersistence.removeSession(session);
  }
}
