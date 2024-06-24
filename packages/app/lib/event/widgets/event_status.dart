import 'package:flutter/material.dart';
import 'package:hollybike/event/types/event_status_state.dart';
import 'package:hollybike/event/types/minimal_event.dart';
import 'package:hollybike/event/widgets/pulsing_dot.dart';
import 'package:hollybike/event/widgets/static_dot.dart';

import '../../shared/utils/dates.dart';

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

  Color _getStatusColor(EventStatusState status) {
    switch (status) {
      case EventStatusState.canceled:
        return Colors.red.shade400;
      case EventStatusState.pending:
        return Colors.blue.shade400;
      case EventStatusState.now:
        return Colors.green.shade400;
      case EventStatusState.finished:
        return Colors.grey;
      case EventStatusState.scheduled:
        return Colors.green.shade400;
    }
  }

  Widget _buildStatusIcon(EventStatusState status) {
    final color = _getStatusColor(status);

    if (status == EventStatusState.now) {
      return PulsingDot(
        size: 13,
        color: Colors.green.shade300,
      );
    }

    return StaticDot(size: 13, color: color);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildStatusIcon(event.status),
        const SizedBox(width: 5),
        _buildStatusText(event.status),
      ],
    );
  }
}
