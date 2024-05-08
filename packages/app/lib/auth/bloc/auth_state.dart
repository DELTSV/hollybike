part of 'auth_bloc.dart';

@immutable
class AuthState {
  final AuthSession? currentSession;
  final List<AuthSession> storedSessions;

  const AuthState({
    this.currentSession,
    required this.storedSessions,
  });

  List<String> toJsonList() {
    return getCurrentSessionJson() +
        storedSessions.map((session) => session.toJson()).toList();
  }

  List<String> getCurrentSessionJson() {
    if (currentSession == null) return <String>[];
    return [currentSession!.toJson()];
  }
}

class AuthInitial extends AuthState {
  AuthInitial() : super(storedSessions: <AuthSession>[]);
}

class AuthStoredSession extends AuthState {
  AuthStoredSession(AuthState currentState)
      : super(
          currentSession: null,
          storedSessions: _aggregateStateSessions(currentState),
        );

  static List<AuthSession> _aggregateStateSessions(AuthState state) {
    final currentSessionList = state.currentSession == null
        ? <AuthSession>[]
        : [state.currentSession as AuthSession];
    return currentSessionList + state.storedSessions;
  }
}

class AuthPersistentSessions extends AuthState {
  AuthPersistentSessions(List<String> sessionsJson)
      : super(
          currentSession: _getCurrentSession(sessionsJson),
          storedSessions: _getStoredSessions(sessionsJson),
        );

  static AuthSession _getCurrentSession(List<String> sessionsJson) {
    return AuthSession.fromJson(sessionsJson.first);
  }

  static List<AuthSession> _getStoredSessions(List<String> sessionsJson) {
    return sessionsJson
        .sublist(1)
        .map((session) => AuthSession.fromJson(session))
        .toList();
  }
}

class AuthNewSession extends AuthState {
  AuthNewSession(AuthSession newSession, AuthState currentState)
      : super(
          currentSession: newSession,
          storedSessions: currentState.storedSessions,
        );
}
