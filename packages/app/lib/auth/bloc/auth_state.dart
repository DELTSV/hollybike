part of 'auth_bloc.dart';

@immutable
class AuthState {
  final bool isPersistentSessionsLoaded;
  final AuthSession? currentSession;
  final List<AuthSession> storedSessions;

  const AuthState({
    this.isPersistentSessionsLoaded = true,
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
  AuthInitial()
      : super(
          isPersistentSessionsLoaded: false,
          storedSessions: <AuthSession>[],
        );
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

class AuthSessionRemove extends AuthState {
  AuthSessionRemove(AuthState currentState, AuthSession sessionToRemove)
      : super(
          currentSession: _filterCurrentSession(currentState, sessionToRemove),
          storedSessions: _filterStoredSessions(currentState, sessionToRemove),
        );

  static AuthSession? _filterCurrentSession(
    AuthState state,
    AuthSession session,
  ) {
    if (state.currentSession == null || state.currentSession!.equal(session)) {
      return null;
    }
    return state.currentSession;
  }

  static List<AuthSession> _filterStoredSessions(
    AuthState state,
    AuthSession session,
  ) {
    return state.storedSessions
        .skipWhile((value) => value.equal(session))
        .toList();
  }
}

class AuthPersistentSessions extends AuthState {
  AuthPersistentSessions(List<AuthSession> sessionsJson)
      : super(
          currentSession: _getCurrentSession(sessionsJson),
          storedSessions: _getStoredSessions(sessionsJson),
        );

  static AuthSession _getCurrentSession(List<AuthSession> sessionsJson) {
    return sessionsJson.first;
  }

  static List<AuthSession> _getStoredSessions(List<AuthSession> sessionsJson) {
    return sessionsJson.sublist(1).toList();
  }
}

class AuthNewSession extends AuthState {
  AuthNewSession(AuthSession newSession, AuthState currentState)
      : super(
          currentSession: newSession,
          storedSessions: currentState.storedSessions,
        );
}
