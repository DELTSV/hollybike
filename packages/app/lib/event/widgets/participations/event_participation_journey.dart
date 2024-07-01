import 'package:flutter/material.dart';
import 'package:hollybike/journey/type/user_journey.dart';

import 'event_participation_journey_content.dart';

class EventParticipationJourney extends StatelessWidget {
  final UserJourney existingJourney;

  const EventParticipationJourney({
    super.key,
    required this.existingJourney,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: EventParticipationJourneyContent(
        existingJourney: existingJourney,
      ),
    );
  }
}
