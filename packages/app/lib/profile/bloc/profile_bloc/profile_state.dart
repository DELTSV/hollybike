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
