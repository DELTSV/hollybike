import 'package:flutter/cupertino.dart';
import 'package:hollybike/event/types/event.dart';

import '../../types/event_status_state.dart';
import 'event_cancelled_warning.dart';
import 'event_pending_warning.dart';

class EventWarningFeed extends StatelessWidget {
  final Event event;

  const EventWarningFeed({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> warnings = [];

    if (event.status == EventStatusState.pending) {
      warnings.add(EventPendingWarning(eventId: event.id));
    }

    if (event.status == EventStatusState.canceled) {
      warnings.add(EventCancelledWarning(eventId: event.id));
    }

    if (warnings.isEmpty) {
      return const SizedBox();
    }

    return Column(
      children: warnings,
    );
  }
}
