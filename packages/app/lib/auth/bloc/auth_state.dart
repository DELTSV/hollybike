part of 'auth_bloc.dart';

@immutable
class AuthState {}

class AuthInitial extends AuthState {}

class AuthConnected extends AuthState {}

class AuthDisconnected extends AuthState {}
