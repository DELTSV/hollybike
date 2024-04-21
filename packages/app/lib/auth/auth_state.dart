part of 'auth_bloc.dart';

@immutable
class AuthState {
  final double count;

  const AuthState(this.count);

  AuthState withIncrement(valueToIncrement) {
    return AuthState(count + valueToIncrement);
  }
}
