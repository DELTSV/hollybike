part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

final class AuthLogin extends AuthEvent {
  final LoginDto loginDto;

  AuthLogin({required this.loginDto});
}
