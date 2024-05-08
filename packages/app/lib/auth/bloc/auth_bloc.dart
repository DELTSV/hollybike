import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hollybike/auth/bloc/auth_repository.dart';
import 'package:hollybike/auth/types/auth_session.dart';
import 'package:hollybike/auth/types/login_dto.dart';
import 'package:hollybike/notification/bloc/notification_repository.dart';
import 'package:hollybike/notification/types/notification_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final NotificationRepository notificationRepository;

  AuthBloc({
    required this.authRepository,
    required this.notificationRepository,
  }) : super(const AuthInitial()) {
    _init();
    on<AuthSessionsFound>((event, emit) {
      emit(AuthPersistentSessions(event.sessionsJson));
    });
    on<AuthLogin>((event, emit) async {
      try {
        final response = await authRepository.login(
          event.host,
          event.loginDto,
        );

        if (response.statusCode != 200) {
          throw NotificationException(response.body);
        }

        final session = AuthSession.fromResponseJson(event.host, response.body);
        emit(AuthNewSession(session));
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

  @override
  void onChange(Change<AuthState> change) {
    super.onChange(change);
    _saveState(change.nextState);
  }

  void _init() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionsList = prefs.getStringList("sessions");

    if (sessionsList != null && sessionsList.isNotEmpty) {
      add(AuthSessionsFound(sessionsJson: sessionsList));
    }
  }

  void _saveState(AuthState state) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList("sessions", state.toJsonList());
  }
}
