import 'package:flutter/material.dart';
import 'package:hollybike/event/types/event_status_state.dart';
import 'package:hollybike/event/types/minimal_event.dart';

import '../../shared/utils/dates.dart';
import 'event_dot.dart';

class EventStatusIndicator extends StatelessWidget {
  final MinimalEvent event;
  final int hoursUntilFinished = 4;

  const EventStatusIndicator({super.key, required this.event});

  Text _buildStatusText(EventStatusState status) {
    switch (status) {
      case EventStatusState.canceled:
        return const Text("Annulé");
      case EventStatusState.pending:
        return const Text("En attente");
      case EventStatusState.now:
        return const Text("En cours");
      case EventStatusState.finished:
        return const Text("Terminé");
      case EventStatusState.scheduled:
        return Text(fromDateToDuration(event.startDate));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        EventDot(
          status: event.status,
          size: 13,
        ),
        const SizedBox(width: 5),
        _buildStatusText(event.status),
      ],
    );
  }
}
