part of 'auth_bloc.dart';

@immutable
class AuthState {
  final AuthSession? currentSession;

  const AuthState({this.currentSession});
}

class AuthInitial extends AuthState {
  const AuthInitial() : super();
}

class AuthNewSession extends AuthState {
  const AuthNewSession(AuthSession newSession)
      : super(currentSession: newSession);
}
