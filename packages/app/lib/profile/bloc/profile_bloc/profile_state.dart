part of 'profile_bloc.dart';

@immutable
abstract class ProfileState {
  final Map<AuthSession, Profile> sessionProfiles;
  final Map<AuthSession, List<MinimalUser>> profiles;
  final AuthSession? currentSession;

  const ProfileState({
    required this.sessionProfiles,
    required this.profiles,
    required this.currentSession,
  });

  Profile? get currentProfile => sessionProfiles[currentSession];

  Profile? findSessionProfile(AuthSession session) {
    if (sessionProfiles.isEmpty) return null;

    try {
      return sessionProfiles.entries
          .firstWhere(
            (element) =>
                element.key.token == session.token &&
                element.key.host == session.host,
          )
          .value;
    } catch (_) {
      return null;
    }
  }
}

class ProfileInitial extends ProfileState {
  ProfileInitial()
      : super(
          sessionProfiles: <AuthSession, Profile>{},
          profiles: <AuthSession, List<MinimalUser>>{},
          currentSession: null,
        );
}

class CurrentSessionChange extends ProfileState {
  CurrentSessionChange({required ProfileState oldState, AuthSession? session})
      : super(
          sessionProfiles: oldState.sessionProfiles,
          profiles: oldState.profiles,
          currentSession: session,
        );
}

class SessionProfileSaving extends ProfileState {
  SessionProfileSaving({
    required ProfileState oldState,
    required Profile profile,
    required AuthSession session,
  }) : super(
          sessionProfiles: <AuthSession, Profile>{
            ...oldState.sessionProfiles,
            ...{session: profile},
          },
          profiles: oldState.profiles,
          currentSession: oldState.currentSession,
        );
}

class ProfileSaving extends ProfileState {
  ProfileSaving({
    required ProfileState oldState,
    required MinimalUser profile,
    required AuthSession session,
  }) : super(
          sessionProfiles: oldState.sessionProfiles,
          profiles: {
            ...oldState.profiles,
            ..._getNewSessionProfileList(oldState, session, profile),
          },
          currentSession: oldState.currentSession,
        );

  static Map<AuthSession, List<MinimalUser>> _getNewSessionProfileList(
    ProfileState oldState,
    AuthSession session,
    MinimalUser profile,
  ) {
    final oldSessionProfileList = oldState.profiles[session];
    if (oldSessionProfileList == null) {
      return {
        session: [profile],
      };
    }

    return {
      session: [
        ...oldSessionProfileList,
        profile,
      ],
    };
  }
}
