import 'package:flutter/material.dart';
import 'package:hollybike/event/widgets/pulsing_dot.dart';
import 'package:hollybike/event/widgets/static_dot.dart';

import '../types/event.dart';
import '../types/event_status_state.dart';

class EventDot extends StatelessWidget {
  final EventStatusState status;
  final double size;

  const EventDot({
    super.key,
    required this.status,
    this.size = 13,
  });

  @override
  Widget build(BuildContext context) {
    final color = Event.getStatusColor(status);

    if (status == EventStatusState.now) {
      return PulsingDot(
        size: size,
        color: color,
      );
    }

    return StaticDot(size: size, color: color);
  }
}
