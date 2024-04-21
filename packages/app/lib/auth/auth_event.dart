part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

final class AuthEventIncrement extends AuthEvent {}
