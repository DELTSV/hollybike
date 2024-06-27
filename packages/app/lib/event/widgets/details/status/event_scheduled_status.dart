import 'package:flutter/material.dart';
import 'package:hollybike/event/widgets/details/status/event_details_status.dart';

import '../../../../shared/utils/dates.dart';
import '../../../types/event_status_state.dart';

class EventScheduledStatus extends StatelessWidget {
  final DateTime startDate;

  const EventScheduledStatus({
    super.key,
    required this.startDate,
  });

  @override
  Widget build(BuildContext context) {
    return EventDetailsStatus(
      status: EventStatusState.scheduled,
      message: fromDateToDuration(startDate),
      actionText: 'Ajouter au calendrier',
      onAction: () {
        _onAddToCalendar(context);
      },
    );
  }

  void _onAddToCalendar(BuildContext context) {}
}
