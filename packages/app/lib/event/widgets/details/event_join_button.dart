/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';

class EventJoinButton extends StatelessWidget {
  final bool isJoined;
  final bool canJoin;

  final void Function(BuildContext context) onJoin;

  const EventJoinButton({
    super.key,
    required this.isJoined,
    required this.canJoin,
    required this.onJoin,
  });

  @override
  Widget build(BuildContext context) {
    if (isJoined) {
      return const ElevatedButton(
        onPressed: null,
        child: Text("Déjà inscrit"),
      );
    }

    if (!canJoin) {
      return const SizedBox();
    }

    return ElevatedButton(
      onPressed: () => onJoin(context),
      child: const Text("Rejoindre"),
    );
  }
}
