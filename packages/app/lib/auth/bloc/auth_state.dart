part of 'auth_bloc.dart';

@immutable
class AuthState {
  final bool isPersistentSessionsLoaded;
  final List<AuthSession> storedSessions;

  const AuthState({
    this.isPersistentSessionsLoaded = true,
    required this.storedSessions,
  });

  AuthSession? get currentSession => storedSessions.firstOrNull;

  List<String> toJsonList() =>
      storedSessions.map((session) => session.toJson()).toList();
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
          storedSessions: _aggregateStateSessions(currentState),
        );

  static List<AuthSession> _aggregateStateSessions(AuthState state) {
    return state.storedSessions;
  }
}

class AuthSessionRemove extends AuthState {
  AuthSessionRemove(AuthState currentState, AuthSession sessionToRemove)
      : super(
          storedSessions: _filterStoredSessions(
            currentState,
            sessionToRemove,
          ),
        );

  static List<AuthSession> _filterStoredSessions(
    AuthState state,
    AuthSession session,
  ) =>
      state.storedSessions.where((value) => !value.equal(session)).toList();
}

class AuthSessionSwitched extends AuthState {
  AuthSessionSwitched(AuthState currentState, AuthSession sessionToReplace)
      : super(
          storedSessions: _replaceStoredSessions(
            currentState,
            sessionToReplace,
          ),
        );

  static List<AuthSession> _replaceStoredSessions(
    AuthState state,
    AuthSession session,
  ) =>
      [session] +
      (state.storedSessions.where((value) => !value.equal(session)).toList());
}

class AuthPersistentSessions extends AuthState {
  const AuthPersistentSessions(List<AuthSession> sessionsJson)
      : super(storedSessions: sessionsJson);
}

class AuthNewSession extends AuthState {
  AuthNewSession(
    AuthSession newSession,
    AuthState currentState,
  ) : super(
          storedSessions: [newSession] + currentState.storedSessions,
        );
}
