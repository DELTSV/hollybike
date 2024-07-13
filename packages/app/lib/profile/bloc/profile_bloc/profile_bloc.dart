import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hollybike/auth/services/auth_session_repository.dart';
import 'package:hollybike/auth/types/auth_session.dart';
import 'package:hollybike/profile/types/profile.dart';
import 'package:hollybike/profile/types/profile_identifier.dart';
import 'package:hollybike/user/types/minimal_user.dart';

import '../../services/profile_repository.dart';

part 'profile_state.dart';
part './events/profile_event.dart';
part './events/profile_load_event.dart';
part './events/user_load_event.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;
  final AuthSessionRepository authSessionRepository;

  ProfileLoadEvent? get currentProfile {
    final session = state.currentSession;
    return session == null ? null : getProfile(session);
  }

  ProfileLoadEvent? getProfile(AuthSession session) {
    try {
      return state.profilesLoad
          .firstWhere((loadEvent) => loadEvent.session == session);
    } catch (_) {
      final futureOrProfile = profileRepository.getProfile(session);

      if (futureOrProfile is Future<Profile>) {
        futureOrProfile.then((profile) {
          add(ProfileLoadSuccessEvent(session: session, profile: profile));
        }, onError: (error) {
          add(ProfileLoadErrorEvent(session: session, error: error));
        });
        add(ProfileLoadingEvent(session: session));
      } else {
        add(
          ProfileLoadSuccessEvent(
            session: session,
            profile: futureOrProfile,
          ),
        );
      }
      return null;
    }
  }

  UserLoadEvent? getUserById(int id) {
    final currentSession = state.currentSession;
    if (currentSession == null) return null;

    try {
      return state.usersLoad.firstWhere((loadEvent) =>
          loadEvent.id == id && loadEvent.observerSession == currentSession);
    } catch (_) {
      final futureOrUser = profileRepository.getUserById(id, currentSession);

      if (futureOrUser is Future<MinimalUser>) {
        futureOrUser.then((user) {
          add(
            UserLoadSuccessEvent(
              observerSession: currentSession,
              id: id,
              user: user,
            ),
          );
        }, onError: (error) {
          add(
            UserLoadErrorEvent(
              observerSession: currentSession,
              id: id,
              error: error,
            ),
          );
        });
        add(UserLoadingEvent(observerSession: currentSession, id: id));
      } else {
        add(
          UserLoadSuccessEvent(
            observerSession: currentSession,
            id: id,
            user: futureOrUser,
          ),
        );
      }
      return null;
    }
  }

  ProfileBloc({
    required this.profileRepository,
    required this.authSessionRepository,
  }) : super(InitialProfileState()) {
    on<SubscribeToCurrentSessionChange>(_onSubscribeToCurrentSessionChange);
    on<SubscribeToInvalidatedProfiles>(_onSubscribeToInvalidatedProfiles);
    on<ProfileLoadEvent>(_onProfileLoadEvent);
    on<UserLoadEvent>(_onUserLoadEvent);
  }

  void _onSubscribeToInvalidatedProfiles(
      SubscribeToInvalidatedProfiles event,
      Emitter<ProfileState> emit,
      ) async {
    await emit.forEach<ProfileIdentifier>(
      profileRepository.profileInvalidationStream,
      onData: (invalidProfile) {
        return InvalidateProfileState(
          oldState: state,
          profileIdentifier: invalidProfile,
        );
      },
    );
  }

  void _onSubscribeToCurrentSessionChange(
    SubscribeToCurrentSessionChange event,
    Emitter<ProfileState> emit,
  ) async {
    await emit.forEach<AuthSession?>(
      authSessionRepository.authSessionStream,
      onData: (session) {
        return ChangedSessionProfileState(
          oldState: state,
          currentSession: session,
        );
      },
    );
  }

  void _onProfileLoadEvent(
    ProfileLoadEvent event,
    Emitter<ProfileState> emit,
  ) {
    emit(
      UpdateLoadEventProfileState(
        oldState: state,
        profileLoadEvent: event,
      ),
    );
  }

  void _onUserLoadEvent(
    UserLoadEvent event,
    Emitter<ProfileState> emit,
  ) {
    emit(
      UpdateLoadEventProfileState(
        oldState: state,
        userLoadEvent: event,
      ),
    );
  }
}
