/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

final class AuthPersistentSessionsLoaded extends AuthEvent {
  final List<AuthSession> persistedSessions;

  AuthPersistentSessionsLoaded({required this.persistedSessions});
}

final class AuthSessionExpired extends AuthEvent {
  final AuthSession expiredSession;

  AuthSessionExpired({required this.expiredSession});
}

final class AuthChangeCurrentSession extends AuthEvent {
  final AuthSession newCurrentSession;

  AuthChangeCurrentSession({required this.newCurrentSession});
}

final class AuthLogin extends AuthEvent {
  final String host;
  final LoginDto loginDto;

  AuthLogin({required this.host, required this.loginDto});
}

final class AuthSignup extends AuthEvent {
  final String host;
  final SignupDto signupDto;

  AuthSignup({required this.host, required this.signupDto});
}
