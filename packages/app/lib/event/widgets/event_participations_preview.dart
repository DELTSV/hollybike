import 'package:flutter/material.dart';
import 'package:hollybike/event/types/event.dart';

import '../types/event_participation.dart';

class EventParticipationsPreview extends StatelessWidget {
  final Event event;
  final List<EventParticipation> participations;
  final int remainingParticipants;

  const EventParticipationsPreview({
    super.key,
    required this.event,
    required this.participations,
    required this.remainingParticipants,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Participants: ${participations.length}'),
        Text('Remaining: $remainingParticipants'),
      ],
    );
  }
}
