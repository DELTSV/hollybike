import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hollybike/auth/bloc/auth_session_repository.dart';
import 'package:hollybike/auth/types/auth_session.dart';
import 'package:hollybike/profile/bloc/profile_repository.dart';
import 'package:hollybike/profile/types/profile.dart';

import '../../auth/types/expired_token_exception.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;
  final AuthSessionRepository authSessionRepository;

  Profile? get currentProfile {
    final profile = state.currentProfile;
    if (profile == null && state.currentSession != null) {
      add(ProfileLoadBySession(session: state.currentSession as AuthSession));
    }
    return profile;
  }

  Profile? getProfileById(int id) {
    final currentSession = state.currentSession;
    if (currentSession == null) return null;

    bool isSearchedProfile(Profile profile) => profile.id == id;

    try {
      return state.sessionProfiles.values.firstWhere(
        isSearchedProfile,
        orElse: () =>
            state.profiles[currentSession]!.firstWhere(isSearchedProfile),
      );
    } catch (_) {
      add(ProfileLoadById(sessionSearching: currentSession, id: id));
      return null;
    }
  }

  ProfileBloc({
    required this.profileRepository,
    required this.authSessionRepository,
  }) : super(ProfileInitial()) {
    on<SubscribeToCurrentSessionChange>(_onSubscribeToCurrentSessionChange);
    on<ProfileLoadBySession>(_onProfileLoadBySession);
    on<ProfileLoadById>(_onProfileLoadById);
  }

  void _onSubscribeToCurrentSessionChange(
    SubscribeToCurrentSessionChange event,
    Emitter<ProfileState> emit,
  ) async {
    await emit.forEach<AuthSession?>(
      authSessionRepository.currentSessionStream,
      onData: (session) {
        return CurrentSessionChange(oldState: state, session: session);
      },
    );
  }

  void _onProfileLoadBySession(
      ProfileLoadBySession event, Emitter<ProfileState> emit) async {
    final session = event.session;

    try {
      final profile = await profileRepository.getSessionProfile(session);

      emit(SessionProfileSaving(
        oldState: state,
        session: session,
        profile: profile,
      ));
    } on ExpiredTokenException catch (_) {
      log('ProfileBloc: session expired');
      authSessionRepository.sessionExpired(event.session);
    }
  }

  void _onProfileLoadById(
    ProfileLoadById event,
    Emitter<ProfileState> emit,
  ) async {
    final profile = await profileRepository.getIdProfile(
      event.sessionSearching,
      event.id,
    );

    emit(ProfileSaving(
      oldState: state,
      session: event.sessionSearching,
      profile: profile,
    ));
  }
}
