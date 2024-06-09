part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent {}

class ProfileLoadBySession extends ProfileEvent {
  final AuthSession session;

  ProfileLoadBySession({
    required this.session,
  });
}

class ProfileCurrentSessionChange extends ProfileEvent {
  final AuthSession? session;

  ProfileCurrentSessionChange({required this.session});
}

class ProfileLoadById extends ProfileEvent {
  final AuthSession sessionSearching;
  final int id;

  ProfileLoadById({required this.sessionSearching, required this.id});
}

class SubscribeToCurrentSessionChange extends ProfileEvent {}
