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

  ProfileBloc({
    required this.profileRepository,
    required this.authSessionRepository,
  }) : super(ProfileInitial()) {
    on<SubscribeToCurrentSessionChange>(_onSubscribeToCurrentSessionChange);
    on<ProfileLoad>(_onProfileLoad);
  }

  void _onSubscribeToCurrentSessionChange(SubscribeToCurrentSessionChange event, Emitter<ProfileState> emit) async {
    await emit.forEach<AuthSession?>(
      authSessionRepository.currentSessionStream,
      onData: (session) {
        if (session == null) {
          return ResetCurrentProfile(oldState: state);
        }

        final foundProfile =  state.findSessionProfile(session);

        if (foundProfile != null) {
          return ProfileCurrentChanged(
            oldState: state,
            profile: state.findSessionProfile(session)!,
          );
        } else {
          add(ProfileLoad(session: session));
        }

        return state;
      },
    );
  }

  void _onProfileLoad(ProfileLoad event, Emitter<ProfileState> emit) async {
    final session = event.session;

    try {
      final profile = await profileRepository.getSessionProfile(session);

      emit(
        ProfileSaving(
          oldState: state,
          session: session,
          profile: profile,
        ),
      );

      emit(
        ProfileCurrentChanged(
          oldState: state,
          profile: profile,
        ),
      );
    } on ExpiredTokenException catch (_) {
      log('ProfileBloc: session expired');
      authSessionRepository.sessionExpired(event.session);
    }
  }
}
