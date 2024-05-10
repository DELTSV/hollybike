part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

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
