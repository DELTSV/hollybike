part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent {}

class ProfileSave extends ProfileEvent {
  final AuthSession session;
  final Profile profile;

  ProfileSave({
    required this.session,
    required this.profile,
  });
}

class ProfileLoad extends ProfileEvent {
  final AuthSession session;

  ProfileLoad({
    required this.session,
  });
}

class ProfileCurrentSessionChange extends ProfileEvent {
  final AuthSession? session;

  ProfileCurrentSessionChange({
    required this.session,
  });
}

class SubscribeToCurrentSessionChange extends ProfileEvent {}