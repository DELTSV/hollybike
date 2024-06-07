part of 'profile_bloc.dart';

@immutable
abstract class ProfileState {
  final Map<AuthSession, Profile> userProfiles;
  final Profile? currentProfile;

  const ProfileState({required this.userProfiles, this.currentProfile});

  Profile? findSessionProfile(AuthSession session) {
    if (userProfiles.isEmpty) return null;

    return userProfiles.entries
        .where(
          (element) =>
              element.key.token == session.token &&
              element.key.host == session.host,
        )
        .firstOrNull
        ?.value;
  }
}

class ProfileInitial extends ProfileState {
  ProfileInitial() : super(userProfiles: <AuthSession, Profile>{});
}

class ProfileSaving extends ProfileState {
  ProfileSaving({
    required ProfileState oldState,
    required AuthSession session,
    required Profile profile,
  }) : super(userProfiles: <AuthSession, Profile>{
          ...oldState.userProfiles,
          session: profile
        });
}

class ProfileCurrentChanged extends ProfileState {
  ProfileCurrentChanged({
    required ProfileState oldState,
    required Profile profile,
  }) : super(userProfiles: oldState.userProfiles, currentProfile: profile);
}

class ResetCurrentProfile extends ProfileState {
  ResetCurrentProfile({
    required ProfileState oldState,
  }) : super(userProfiles: oldState.userProfiles);
}