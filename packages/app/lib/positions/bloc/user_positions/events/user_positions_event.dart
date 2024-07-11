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
