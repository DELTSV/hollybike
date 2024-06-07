part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

final class SubscribeToAuthSessionExpiration extends AuthEvent {
  SubscribeToAuthSessionExpiration();
}

final class AuthPersistentSessionsLoaded extends AuthEvent {
  final List<AuthSession> sessionsJson;

  AuthPersistentSessionsLoaded({required this.sessionsJson});
}

final class AuthSessionExpired extends AuthEvent {
  final AuthSession expiredSession;

  AuthSessionExpired({required this.expiredSession});
}

final class AuthSessionSwitch extends AuthEvent {
  final AuthSession newSession;

  AuthSessionSwitch({required this.newSession});
}

final class AuthStoreCurrentSession extends AuthEvent {
  AuthStoreCurrentSession();
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
