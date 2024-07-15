part of 'profile_bloc.dart';

@immutable
class ProfileState {
  final List<ProfileLoadEvent> profilesLoad;
  final List<UserLoadEvent> usersLoad;
  final AuthSession? currentSession;

  const ProfileState({
    required this.profilesLoad,
    required this.usersLoad,
    required this.currentSession,
  });
}

class InitialProfileState extends ProfileState {
  InitialProfileState()
      : super(
          profilesLoad: <ProfileLoadEvent>[],
          usersLoad: <UserLoadEvent>[],
          currentSession: null,
        );
}

class ChangedSessionProfileState extends ProfileState {
  ChangedSessionProfileState({
    required ProfileState oldState,
    required super.currentSession,
  }) : super(
          profilesLoad: oldState.profilesLoad,
          usersLoad: oldState.usersLoad,
        );
}

class UpdateLoadEventProfileState extends ProfileState {
  UpdateLoadEventProfileState({
    required ProfileState oldState,
    ProfileLoadEvent? profileLoadEvent,
    UserLoadEvent? userLoadEvent,
  }) : super(
          profilesLoad: oldState.profilesLoad.copyUpdatedFromNullable(
            profileLoadEvent,
          ),
          usersLoad: oldState.usersLoad.copyUpdatedFromNullable(
            userLoadEvent,
          ),
          currentSession: oldState.currentSession,
        );
}

class InvalidateProfileState extends ProfileState {
  InvalidateProfileState({
    required ProfileState oldState,
    required ProfileIdentifier profileIdentifier,
  }) : super(
          profilesLoad: oldState.profilesLoad
              .where((profile) {
                final isSuccess = profile is ProfileLoadSuccessEvent;

                final isSession = profile.session == profileIdentifier.session;

                if (isSession && profileIdentifier.id == null) {
                  return false;
                }

                final isUser = isSuccess && profile.profile.id == profileIdentifier.id;

                if (isUser && isSession) {
                  return false;
                }

                return true;
          })
              .toList(),
          usersLoad: profileIdentifier.id == null ? oldState.usersLoad : oldState.usersLoad
              .where(
                (user) => !(user.observerSession == profileIdentifier.session &&
                    user.id == profileIdentifier.id),
              )
              .toList(),
          currentSession: oldState.currentSession,
        );
}
