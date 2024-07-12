part of '../profile_bloc.dart';

abstract class UserLoadEvent extends ProfileEvent {
  final AuthSession observerSession;
  final int id;

  const UserLoadEvent({required this.observerSession, required this.id})
      : super();

  @override
  bool operator ==(covariant UserLoadEvent other) {
    return observerSession == other.observerSession && id == other.id;
  }

  @override
  int get hashCode => Object.hash(observerSession, id.hashCode);
}

class UserLoadingEvent extends UserLoadEvent {
  const UserLoadingEvent({required super.observerSession, required super.id});
}

class UserLoadSuccessEvent extends UserLoadEvent {
  final MinimalUser user;

  const UserLoadSuccessEvent({
    required super.observerSession,
    required super.id,
    required this.user,
  });
}

class UserLoadErrorEvent extends UserLoadEvent {
  final Error error;

  const UserLoadErrorEvent({
    required super.observerSession,
    required super.id,
    required this.error,
  });
}
