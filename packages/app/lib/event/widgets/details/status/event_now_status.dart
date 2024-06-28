import 'package:flutter/material.dart';
import 'package:hollybike/event/types/event_details.dart';
import 'package:hollybike/event/widgets/details/status/event_details_status.dart';

import '../../../types/event_status_state.dart';

class EventNowStatus extends StatelessWidget {
  final EventDetails eventDetails;
  final bool isShared;
  final bool isLoading;

  const EventNowStatus({
    super.key,
    required this.eventDetails,
    required this.isShared,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return EventDetailsStatusBadge(
      loading: isLoading,
      status: EventStatusState.now,
      message: 'L\'événement est en cours',
      actionText: 'Terminer le parcours',
      onAction: () => {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Terminer le parcours"),
              content: const Text(
                "Êtes-vous sûr de vouloir terminer le parcours ? Vous ne pourrez plus partager votre position en temps réel.",
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Annuler"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Terminer"),
                ),
              ],
            );
          },
        ),
      },
    );
  }
}
