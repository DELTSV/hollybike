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
