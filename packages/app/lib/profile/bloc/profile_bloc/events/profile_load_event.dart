part of '../profile_bloc.dart';

abstract class ProfileLoadEvent extends ProfileEvent {
  final AuthSession session;

  const ProfileLoadEvent({required this.session}) : super();

  @override
  bool operator ==(covariant ProfileLoadEvent other) {
    return session == other.session;
  }

  @override
  int get hashCode => Object.hash(session, super.hashCode);
}

class ProfileLoadingEvent extends ProfileLoadEvent {
  const ProfileLoadingEvent({required super.session});

  ProfileLoadSuccessEvent succeeded(Profile profile) =>
      ProfileLoadSuccessEvent(session: session, profile: profile);

  ProfileLoadErrorEvent failed(Error error) =>
      ProfileLoadErrorEvent(session: session, error: error);
}

class ProfileLoadSuccessEvent extends ProfileLoadEvent {
  final Profile profile;

  const ProfileLoadSuccessEvent({
    required super.session,
    required this.profile,
  });
}

class ProfileLoadErrorEvent extends ProfileLoadEvent {
  final Error error;

  const ProfileLoadErrorEvent({
    required super.session,
    required this.error,
  });
}

extension ProfileLoadEventFactories on ProfileLoadEvent {
  static ProfileLoadingEvent loading({
    required AuthSession session,
  }) =>
      ProfileLoadingEvent(session: session);

  static ProfileLoadSuccessEvent success({
    required AuthSession session,
    required Profile profile,
  }) =>
      ProfileLoadSuccessEvent(session: session, profile: profile);

  static ProfileLoadErrorEvent error({
    required AuthSession session,
    required Error error,
  }) =>
      ProfileLoadErrorEvent(session: session, error: error);
}

