import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hollybike/auth/bloc/auth_repository.dart';
import 'package:hollybike/auth/types/login_dto.dart';
import 'package:hollybike/notification/bloc/notification_repository.dart';
import 'package:hollybike/notification/types/notification_exception.dart';

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
      try {
        final response = await authRepository.login(
          event.host,
          event.loginDto,
        );
        print("${response.statusCode} ${response.body}");

        if (response.statusCode == 200) {
          return;
        }
        throw NotificationException(response.body);
      } on NotificationException catch (exception) {
        notificationRepository.push(
          exception.message,
          isError: true,
          consumerId: "loginForm",
        );
      } catch (_) {
        notificationRepository.push(
          "Oups! Il semble y avoir une erreur. Veuillez vérifier l'adresse du serveur et réessayer.",
          isError: true,
          consumerId: "loginForm",
        );
      }
    });
  }
}
