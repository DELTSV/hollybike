part of '../profile_bloc.dart';

@immutable
abstract class ProfileEvent {
  const ProfileEvent();
}

class SubscribeToCurrentSessionChange extends ProfileEvent {}

extension ProfileEventOperations<T extends ProfileEvent> on List<T> {
  int? elementIndex(T profileEvent) {
    for (int i = 0; i < length; i++) {
      if (profileEvent == this[i]) return i;
    }
    return null;
  }

  copyUpdatedFromNullable(T? profileEvent) {
    final copy = [...this];
    if (profileEvent == null) return copy;

    final alreadyExistingLoadEvent = elementIndex(profileEvent);
    if (alreadyExistingLoadEvent is int) {
      copy[alreadyExistingLoadEvent] = profileEvent;
    } else {
      copy.add(profileEvent);
    }

    return copy;
  }
}
