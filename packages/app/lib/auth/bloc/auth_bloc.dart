import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hollybike/auth/bloc/auth_repository.dart';
import 'package:hollybike/auth/types/auth_session.dart';
import 'package:hollybike/auth/types/login_dto.dart';
import 'package:hollybike/auth/types/signup_dto.dart';
import 'package:hollybike/notification/bloc/notification_repository.dart';
import 'package:hollybike/notification/types/notification_exception.dart';

import '../../profile/bloc/profile_repository.dart';
import 'auth_session_repository.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final AuthSessionRepository authSessionRepository;
  final ProfileRepository profileRepository;
  final NotificationRepository notificationRepository;

  AuthBloc({
    required this.authRepository,
    required this.authSessionRepository,
    required this.profileRepository,
    required this.notificationRepository,
  }) : super(AuthInitial()) {
    _init();
    on<AuthPersistentSessionsLoaded>(_onAuthSessionsLoaded);
    on<AuthChangeCurrentSession>(_onCurrentSessionChange);
    on<AuthLogin>(_onLogin);
    on<AuthSignup>(_onSignup);
  }

  void _onAuthSessionsLoaded(AuthPersistentSessionsLoaded event, Emitter<AuthState> emit) {
    authSessionRepository.setCurrentSession(event.sessionsJson.firstOrNull);
    emit(AuthPersistentSessions(event.sessionsJson));
  }

  void _onStoreCurrentSession(AuthStoreCurrentSession event, Emitter<AuthState> emit) {
    emit(AuthStoredSession(state));
  }

  @override
  void onChange(Change<AuthState> change) {
    super.onChange(change);
    authSessionRepository.authSessionState = change.nextState;
  }

  void _onAuthSessionsLoaded(
    AuthPersistentSessionsLoaded event,
    Emitter<AuthState> emit,
  ) {
    emit(
      event.persistedSessions.isEmpty ? AuthDisconnected() : AuthConnected(),
    );
  }

  void _onCurrentSessionChange(
    AuthChangeCurrentSession event,
    Emitter<AuthState> emit,
  ) {
    authRepository.currentSession = event.newCurrentSession;
    emit(AuthConnected());
  }

  void _onLogin(AuthLogin event, Emitter<AuthState> emit) async {
    try {
      final session = await authRepository.login(
        event.host,
        event.loginDto,
      );

      authRepository.currentSession = session;
      emit(AuthConnected());
    } on NotificationException catch (exception) {
      notificationRepository.push(
        exception.message,
        isError: true,
        consumerId: "loginForm",
      );
    } catch (e) {
      log(e.toString());
      notificationRepository.push(
        "Oups! Il semble y avoir une erreur. Veuillez vérifier l'adresse du serveur et réessayer.",
        isError: true,
        consumerId: "loginForm",
      );
    }
  }

  void _onSignup(AuthSignup event, Emitter<AuthState> emit) async {
    try {
      final session = await authRepository.signup(
        event.host,
        event.signupDto,
      );

      authRepository.currentSession = session;
      emit(AuthConnected());
    } on NotificationException catch (exception) {
      notificationRepository.push(
        exception.message,
        isError: true,
        consumerId: "signupForm",
      );
    } catch (e) {
      notificationRepository.push(
        "Il semble que le lien d'invitation que vous utilisez est invalide.",
        isError: true,
        consumerId: "signupForm",
      );
    }
  }
}
