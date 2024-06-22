import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hollybike/auth/bloc/auth_repository.dart';
import 'package:hollybike/auth/types/auth_session.dart';
import 'package:hollybike/auth/types/login_dto.dart';
import 'package:hollybike/auth/types/signup_dto.dart';
import 'package:hollybike/notification/bloc/notification_repository.dart';
import 'package:hollybike/notification/types/notification_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    on<SubscribeToAuthSessionExpiration>(_onSubscribeToAuthSessionExpiration);
    on<AuthPersistentSessionsLoaded>(_onAuthSessionsLoaded);
    on<AuthSessionSwitch>(_onSessionSwitch);
    on<AuthStoreCurrentSession>(_onStoreCurrentSession);
    on<AuthLogin>(_onLogin);
    on<AuthSignup>(_onSignup);
  }

  void _onAuthSessionsLoaded(
      AuthPersistentSessionsLoaded event, Emitter<AuthState> emit) {
    authSessionRepository.setCurrentSession(event.sessionsJson.firstOrNull);
    emit(AuthPersistentSessions(event.sessionsJson));
  }

  void _onStoreCurrentSession(
      AuthStoreCurrentSession event, Emitter<AuthState> emit) {
    emit(AuthStoredSession(state));
  }

  void _onSessionSwitch(AuthSessionSwitch event, Emitter<AuthState> emit) {
    authSessionRepository.setCurrentSession(event.newSession);
    emit(AuthSessionSwitched(state, event.newSession));
  }

  void _onSubscribeToAuthSessionExpiration(
    SubscribeToAuthSessionExpiration event,
    Emitter<AuthState> emit,
  ) async {
    await emit.forEach<AuthSession>(
      authSessionRepository.expirationStream,
      onData: (session) => AuthSessionRemove(state, session),
    );
  }

  void _onLogin(AuthLogin event, Emitter<AuthState> emit) async {
    try {
      final session = await authRepository.login(
        event.host,
        event.loginDto,
      );

      authSessionRepository.setCurrentSession(session);
      emit(AuthNewSession(session, state));
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


      authSessionRepository.setCurrentSession(session);
      emit(AuthNewSession(session, state));
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
