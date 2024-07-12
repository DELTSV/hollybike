part of '../user_positions_bloc.dart';

@immutable
abstract class UserPositionsEvent {
  const UserPositionsEvent();
}

class SubscribeToUserPositions extends UserPositionsEvent {
  final int eventId;

  const SubscribeToUserPositions({
    required this.eventId,
  });
}

extension ProfileEventOperations<T extends UserPositionsEvent> on List<T> {
  int? elementIndex(T userLoadEvent) {
    for (int i = 0; i < length; i++) {
      if (userLoadEvent == this[i]) return i;
    }
    return null;
  }

  copyUpdated(T profileEvent) {
    final copy = [...this];
    final alreadyExistingLoadEvent = elementIndex(profileEvent);
    if (alreadyExistingLoadEvent is int) {
      copy[alreadyExistingLoadEvent] = profileEvent;
    } else {
      copy.add(profileEvent);
    }
    return copy;
  }
}
