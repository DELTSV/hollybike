import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hollybike/auth/services/auth_repository.dart';
import 'package:hollybike/auth/types/auth_session.dart';
import 'package:hollybike/auth/types/login_dto.dart';
import 'package:hollybike/auth/types/signup_dto.dart';

import '../../profile/services/profile_repository.dart';
import '../services/auth_session_repository.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final AuthSessionRepository authSessionRepository;
  final ProfileRepository profileRepository;

  AuthBloc({
    required this.authRepository,
    required this.authSessionRepository,
    required this.profileRepository,
  }) : super(const AuthInitial()) {
    _init();
    on<AuthPersistentSessionsLoaded>(_onAuthSessionsLoaded);
    on<AuthChangeCurrentSession>(_onCurrentSessionChange);
    on<AuthLogin>(_onLogin);
    on<AuthSignup>(_onSignup);
    on<AuthSessionExpired>(_onSessionExpired);
  }

  void _init() async {
    final persistedSessions = await authRepository.retrievePersistedSessions();
    add(AuthPersistentSessionsLoaded(persistedSessions: persistedSessions));
  }

  @override
  void onChange(Change<AuthState> change) {
    super.onChange(change);

    if (change.nextState is AuthFailure) return;

    authSessionRepository.authSessionState = change.nextState.authSession;
  }

  void _onAuthSessionsLoaded(
    AuthPersistentSessionsLoaded event,
    Emitter<AuthState> emit,
  ) {
    emit(
      event.persistedSessions.isEmpty
          ? const AuthDisconnected()
          : AuthConnected(authSession: event.persistedSessions[0]),
    );
  }

  void _onCurrentSessionChange(
    AuthChangeCurrentSession event,
    Emitter<AuthState> emit,
  ) {
    authRepository.currentSession = event.newCurrentSession;
    emit(AuthConnected(authSession: event.newCurrentSession));
  }

  void _onLogin(AuthLogin event, Emitter<AuthState> emit) async {
    const defaultError =
        "Oups! Il semble y avoir une erreur. Veuillez vérifier l'adresse du serveur et réessayer.";

    try {
      final session = await authRepository.login(
        event.host,
        event.loginDto,
      );

      authRepository.currentSession = session;
      emit(AuthConnected(authSession: session));
    } on DioException catch (exception) {
      emit(AuthFailure(
        message: exception.response?.data ?? defaultError,
        authSession: state.authSession,
      ));
    } catch (e) {
      log(e.toString());
      emit(AuthFailure(
        message: defaultError,
        authSession: state.authSession,
      ));
    }
  }

  void _onSignup(AuthSignup event, Emitter<AuthState> emit) async {
    const defaultError =
        "Il semble que le lien d'invitation que vous utilisez est invalide.";

    try {
      final session = await authRepository.signup(
        event.host,
        event.signupDto,
      );

      authRepository.currentSession = session;
      emit(AuthConnected(authSession: session));
    } on DioException catch (exception) {
      emit(
        AuthFailure(
          message: exception.response?.data ?? defaultError,
          authSession: state.authSession,
        ),
      );
    } catch (e) {
      log(e.toString());
      emit(
        AuthFailure(
          message: defaultError,
          authSession: state.authSession,
        ),
      );
    }
  }

  void _onSessionExpired(
      AuthSessionExpired event, Emitter<AuthState> emit) async {
    await authRepository.removeSession(event.expiredSession);

    final currentSession = await authRepository.currentSession;

    if (currentSession == null) {
      emit(const AuthDisconnected());
      return;
    }

    emit(AuthConnected(authSession: currentSession));
  }
}
