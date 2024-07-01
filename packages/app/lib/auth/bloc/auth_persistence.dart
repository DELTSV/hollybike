import 'dart:async';

import 'package:hollybike/auth/types/auth_session.dart';
import 'package:hollybike/shared/utils/calculate_future_or_list.dart';
import 'package:hollybike/shared/utils/apply_on_future_or.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthPersistence {
  final String key = "sessions";

  FutureOr<List<AuthSession>> get sessions async =>
      (await SharedPreferences.getInstance())
          .getStringList(key)
          ?.map(AuthSession.fromJson)
          .toList() ??
      <AuthSession>[];

  Future<bool> get isConnected async => (await sessions).isNotEmpty;

  Future<bool> get isDisconnected async => !(await isConnected);

  final BehaviorSubject<AuthSession> _expiredSession = BehaviorSubject();

  Stream<AuthSession> get currentSessionExpiredStream => _expiredSession.stream;

  bool currentSessionExpired = false;

  set expiredCurrentSession(AuthSession session) {
    _expiredSession.add(session);
    currentSessionExpired = true;
  }

  set sessions(FutureOr<List<AuthSession>> newFutureSessions) {
    SharedPreferences.getInstance().then((sharedPreferences) {
      newFutureSessions.apply((newSessions) {
        sharedPreferences.setStringList(
            key,
            newSessions.map((newSession) => newSession.toJson()).toList(),
        );
      });
    });
  }

  FutureOr<AuthSession?> get currentSession async => (await sessions).firstOrNull;

  set currentSession(FutureOr<AuthSession?> session) {
    if (session == null) return;

    currentSessionExpired = false;

    final FutureOr<List<AuthSession>> filteredSessions = sessions - (session as FutureOr<AuthSession>);
    sessions = filteredSessions.add(session);
  }

  Future<void> removeSession(AuthSession session) async {
    sessions = sessions - session;
  }

  final _oldNewSessionCorrespondence = <AuthSession, AuthSession>{};

  Future<void> replaceSession(AuthSession oldSession, AuthSession newSession) async {
    _oldNewSessionCorrespondence[oldSession] = newSession;
    sessions = (sessions - oldSession).add(newSession);
  }

  removeCorrespondence(AuthSession oldSession) {
    _oldNewSessionCorrespondence.remove(oldSession);
  }

  AuthSession? getNewSession(AuthSession oldSession) => _oldNewSessionCorrespondence[oldSession];

  Future<AuthSession?> getSessionByToken(String token) async {
    try {
      return (await sessions).firstWhere((session) => session.token == token);
    } catch (e) {
      return null;
    }
  }

  bool _refreshing = false;
  Completer<void>? _refreshingCompleter;

  bool get refreshing => _refreshing;

  set refreshing(bool value) {
    _refreshing = value;
    if (!value && _refreshingCompleter != null && !_refreshingCompleter!.isCompleted) {
      _refreshingCompleter!.complete();
    }
  }

  Future<void> waitIfRefreshing({Duration timeout = const Duration(seconds: 20)}) async {
    if (!_refreshing) return;

    _refreshingCompleter = Completer<void>();
    try {
      await _refreshingCompleter!.future.timeout(timeout);
    } catch (e) {
      return;
    } finally {
      _refreshingCompleter = null;
    }
  }
}
