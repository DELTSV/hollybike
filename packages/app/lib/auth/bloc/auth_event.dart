part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

final class AuthSessionsFound extends AuthEvent {
  final List<String> sessionsJson;

  AuthSessionsFound({required this.sessionsJson});
}

final class AuthLogin extends AuthEvent {
  final String host;
  final LoginDto loginDto;

  AuthLogin({required this.host, required this.loginDto});
}
