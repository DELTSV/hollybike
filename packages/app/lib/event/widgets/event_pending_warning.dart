import 'package:flutter/material.dart';

class EventPendingWarning extends StatelessWidget {
  final void Function() onAction;

  const EventPendingWarning({super.key, required this.onAction});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.2),
        border: Border.all(
          color: Colors.blueAccent.withOpacity(0.3),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text("Cet événement en attente."),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size.zero,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              surfaceTintColor: Colors.blueAccent.withOpacity(1),
              backgroundColor: Colors.blueAccent.withOpacity(1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: onAction,
            child: const Text("Publier"),
          ),
        ],
      ),
    );
  }
}
