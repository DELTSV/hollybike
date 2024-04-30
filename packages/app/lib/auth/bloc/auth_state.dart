part of 'auth_bloc.dart';

@immutable
class AuthState {
  final String? token;

  const AuthState(this.token);
}

class AuthInitial extends AuthState {
  const AuthInitial() : super(null);
}
