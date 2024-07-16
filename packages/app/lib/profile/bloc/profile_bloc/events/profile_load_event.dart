/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
part of '../profile_bloc.dart';

abstract class ProfileLoadEvent extends ProfileEvent {
  final AuthSession session;

  const ProfileLoadEvent({
    required this.session,
  }) : super();

  @override
  bool operator ==(covariant ProfileLoadEvent other) {
    return session == other.session;
  }

  @override
  int get hashCode => Object.hash(session, super.hashCode);
}

class ProfileLoadingEvent extends ProfileLoadEvent {
  const ProfileLoadingEvent({
    required super.session,
  });
}

class ProfileLoadSuccessEvent extends ProfileLoadEvent {
  final Profile profile;
  final DateTime expiredAt;

  ProfileLoadSuccessEvent({
    required super.session,
    required this.profile,
  }) : expiredAt = DateTime.now().add(const Duration(minutes: 59));
}

class ProfileLoadErrorEvent extends ProfileLoadEvent {
  final Error error;

  const ProfileLoadErrorEvent({
    required super.session,
    required this.error,
  });
}
