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

  UserLoadSuccessEvent succeeded(MinimalUser user) => UserLoadSuccessEvent(
        observerSession: observerSession,
        id: id,
        user: user,
      );

  UserLoadErrorEvent failed(Error error) => UserLoadErrorEvent(
        observerSession: observerSession,
        id: id,
        error: error,
      );
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

extension UserLoadEventFactories on UserLoadEvent {
  static UserLoadingEvent loading({
    required AuthSession observerSession,
    required int id,
  }) =>
      UserLoadingEvent(observerSession: observerSession, id: id);

  static UserLoadSuccessEvent success({
    required AuthSession observerSession,
    required int id,
    required MinimalUser user,
  }) =>
      UserLoadSuccessEvent(
        observerSession: observerSession,
        id: id,
        user: user,
      );

  static UserLoadErrorEvent error({
    required AuthSession observerSession,
    required int id,
    required Error error,
  }) =>
      UserLoadErrorEvent(
        observerSession: observerSession,
        id: id,
        error: error,
      );
}
