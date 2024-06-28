import 'dart:async';

import 'package:hollybike/auth/types/auth_session.dart';
import 'package:hollybike/shared/utils/calculate_future_or_list.dart';
import 'package:hollybike/shared/utils/apply_on_future_or.dart';
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

    final FutureOr<List<AuthSession>> filteredSessions = sessions - (session as FutureOr<AuthSession>);
    sessions = filteredSessions.add(session);
  }

  Future<void> removeSession(AuthSession session) async {
    sessions = sessions - session;
  }
}
