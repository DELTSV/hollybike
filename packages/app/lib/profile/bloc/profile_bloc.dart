import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hollybike/auth/bloc/auth_repository.dart';
import 'package:hollybike/auth/bloc/auth_session_repository.dart';
import 'package:hollybike/auth/types/auth_session.dart';
import 'package:hollybike/profile/types/profile.dart';
import 'package:hollybike/user/types/minimal_user.dart';

import '../services/profile_repository.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;
  final AuthRepository authRepository;
  final AuthSessionRepository authSessionRepository;

  bool _loading = false;

  Profile? get currentProfile {
    final profile = state.currentProfile;
    if (profile == null && state.currentSession != null && !_loading) {
      _loading = true;
      add(ProfileLoadBySession(session: state.currentSession as AuthSession));
    }
    return profile;
  }

  MinimalUser? getProfileById(int id) {
    final currentSession = state.currentSession;
    if (currentSession == null) return null;

    bool isSearchedProfile(MinimalUser profile) => profile.id == id;

    try {
      return state.sessionProfiles.values
          .map((sessionProfile) => sessionProfile.toMinimalUser())
          .firstWhere(
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
    required this.authRepository,
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
      authSessionRepository.authSessionStream,
      onData: (session) {
        return CurrentSessionChange(
          oldState: state,
          session: session,
        );
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

      _loading = false;
    } catch (_) {}
  }

  void _onProfileLoadById(
    ProfileLoadById event,
    Emitter<ProfileState> emit,
  ) async {
    final profile = await profileRepository.getIdProfile(
      event.id,
    );

    emit(ProfileSaving(
      oldState: state,
      session: event.sessionSearching,
      profile: profile,
    ));
  }
}
