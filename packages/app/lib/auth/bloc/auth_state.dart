/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
part of 'auth_bloc.dart';

@immutable
class AuthState {
  final AuthSession? authSession;

  const AuthState({required this.authSession});
}

class AuthInitial extends AuthState {
  const AuthInitial() : super(authSession: null);
}

class AuthConnected extends AuthState {
  const AuthConnected({required AuthSession authSession})
      : super(authSession: authSession);
}

class AuthDisconnected extends AuthState {
  const AuthDisconnected() : super(authSession: null);
}

class AuthFailure extends AuthState {
  final String message;

  const AuthFailure({required this.message, required super.authSession});
}