import 'package:flutter/material.dart';
import 'package:hollybike/event/types/event_status_state.dart';
import 'package:hollybike/event/types/minimal_event.dart';
import 'package:hollybike/event/widgets/pulsing_dot.dart';

import '../../shared/utils/dates.dart';

enum EventDisplayStatus {
  canceled,
  pending,
  scheduled,
  ongoing,
  finished,
}

class EventStatusIndicator extends StatelessWidget {
  final MinimalEvent event;
  final int hoursUntilFinished = 4;

  const EventStatusIndicator({super.key, required this.event});

  EventDisplayStatus _getEventDisplayStatus() {
    if (event.status == EventStatusState.canceled) {
      return EventDisplayStatus.canceled;
    }

    if (event.status == EventStatusState.pending) {
      return EventDisplayStatus.pending;
    }

    if (event.endDate != null &&
        (event.startDate.isBefore(DateTime.now()) &&
                event.endDate!.isAfter(DateTime.now()) ||
            event.startDate.isBefore(DateTime.now()) &&
                event.startDate
                    .add(Duration(hours: hoursUntilFinished))
                    .isAfter(DateTime.now()))) {
      return EventDisplayStatus.ongoing;
    } else if (event.startDate.isBefore(DateTime.now()) ||
        event.status == EventStatusState.finished) {
      return EventDisplayStatus.finished;
    }

    return EventDisplayStatus.scheduled;
  }

  Text _buildStatusText(EventDisplayStatus status) {
    switch (status) {
      case EventDisplayStatus.canceled:
        return const Text("Annulé");
      case EventDisplayStatus.pending:
        return const Text("En attente");
      case EventDisplayStatus.ongoing:
        return const Text("En cours");
      case EventDisplayStatus.finished:
        return const Text("Terminé");
      case EventDisplayStatus.scheduled:
        return Text(fromDateToDuration(event.startDate));
    }
  }

  Color _getStatusColor(EventDisplayStatus status) {
    switch (status) {
      case EventDisplayStatus.canceled:
        return Colors.red;
      case EventDisplayStatus.pending:
        return Colors.blue;
      case EventDisplayStatus.ongoing:
        return Colors.green;
      case EventDisplayStatus.finished:
        return Colors.grey;
      case EventDisplayStatus.scheduled:
        return Colors.green;
    }
  }

  Widget _buildStatusIcon(EventDisplayStatus status) {
    final color = _getStatusColor(status);

    if (status == EventDisplayStatus.ongoing) {
      return const PulsingDot(
        size: 13,
      );
    }

    return Icon(
      Icons.circle,
      size: 13,
      color: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    final status = _getEventDisplayStatus();

    return Row(
      children: [
        _buildStatusIcon(status),
        const SizedBox(width: 5),
        _buildStatusText(status),
      ],
    );
  }
}
