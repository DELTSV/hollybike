import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hollybike/auth/bloc/auth_repository.dart';
import 'package:hollybike/auth/types/login_dto.dart';
import 'package:hollybike/notification/bloc/notification_repository.dart';
import 'package:http/http.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final NotificationRepository notificationRepository;

  AuthBloc({
    required this.authRepository,
    required this.notificationRepository,
  }) : super(const AuthInitial()) {
    on<AuthLogin>((event, emit) async {
      final response = await authRepository.login(
        "http://192.168.1.191:8080",
        event.loginDto,
      );

      if (response.statusCode == 200) {
        return;
      }
      notificationRepository.push(
        response.body,
        isError: true,
        consumerId: "loginForm",
      );
    });
  }
}
