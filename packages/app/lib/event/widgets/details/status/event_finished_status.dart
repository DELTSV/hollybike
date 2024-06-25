import 'package:flutter/material.dart';
import 'package:hollybike/event/types/event_status_state.dart';
import 'package:hollybike/event/widgets/details/status/event_details_status.dart';

import '../../../../shared/utils/dates.dart';

class EventFinishedStatus extends StatelessWidget {
  final DateTime endDate;

  const EventFinishedStatus({
    super.key,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    return EventDetailsStatus(
      height: 60,
      status: EventStatusState.finished,
      message: 'Terminé ${formatPastTime(endDate)}',
    );
  }
}
