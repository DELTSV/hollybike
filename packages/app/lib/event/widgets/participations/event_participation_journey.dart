import 'package:flutter/material.dart';
import 'package:hollybike/journey/type/user_journey.dart';

import 'event_participation_journey_content.dart';
import 'event_participation_journey_empty.dart';

class EventParticipationJourney extends StatelessWidget {
  final UserJourney? journey;
  final String username;

  const EventParticipationJourney({
    super.key,
    required this.journey,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    if (journey == null) {
      return SizedBox(
        height: 80,
        child: EventParticipationJourneyEmpty(
          username: username,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: EventParticipationJourneyContent(
        existingJourney: journey!,
      ),
    );
  }
}
