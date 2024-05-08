part of 'auth_bloc.dart';

@immutable
class AuthState {
  final AuthSession? currentSession;

  const AuthState({this.currentSession});

  List<String> toJsonList() {
    return getCurrentSessionJson();
  }

  List<String> getCurrentSessionJson() {
    if (currentSession == null) return <String>[];
    return [currentSession!.toJson()];
  }
}

class AuthInitial extends AuthState {
  const AuthInitial() : super();
}

class AuthPersistentSessions extends AuthState {
  AuthPersistentSessions(List<String> sessionsJson)
      : super(currentSession: _getCurrentSession(sessionsJson));

  static AuthSession _getCurrentSession(List<String> sessionsJson) {
    return AuthSession.fromJson(sessionsJson.first);
  }
}

class AuthNewSession extends AuthState {
  const AuthNewSession(AuthSession newSession)
      : super(currentSession: newSession);
}
