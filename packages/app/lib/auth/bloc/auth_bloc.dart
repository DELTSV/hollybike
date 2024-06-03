import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hollybike/auth/bloc/auth_repository.dart';
import 'package:hollybike/auth/types/auth_session.dart';
import 'package:hollybike/auth/types/login_dto.dart';
import 'package:hollybike/auth/types/signup_dto.dart';
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
  }) : super(AuthInitial()) {
    _init();
    on<AuthPersistentSessionsLoaded>((event, emit) {
      emit(AuthPersistentSessions(event.sessionsJson));
    });
    on<AuthSessionExpired>((event, emit) {
      emit(AuthSessionRemove(state, event.expiredSession));
    });
    on<AuthSessionSwitch>((event, emit) {
      emit(AuthSessionSwitched(state, event.newSession));
    });
    on<AuthStoreCurrentSession>((event, emit) {
      emit(AuthStoredSession(state));
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
        emit(AuthNewSession(session, state));
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
    on<AuthSignup>((event, emit) async {
      try {
        final response = await authRepository.signup(
          event.host,
          event.signupDto,
        );

        if (response.statusCode != 200) {
          throw NotificationException(response.body);
        }

        final session = AuthSession.fromResponseJson(event.host, response.body);
        emit(AuthNewSession(session, state));
      } on NotificationException catch (exception) {
        notificationRepository.push(
          exception.message,
          isError: true,
          consumerId: "signupForm",
        );
      } catch (e) {
        print('error $e');
        notificationRepository.push(
          "Il semble que le lien d'invitation que vous utilisez est invalide.",
          isError: true,
          consumerId: "signupForm",
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
    final persistedSessions = await authRepository.retrievePersistedSessions();
    add(AuthPersistentSessionsLoaded(sessionsJson: persistedSessions));
  }

  void _saveState(AuthState state) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList("sessions", state.toJsonList());
  }
}
