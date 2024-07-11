import 'package:flutter/material.dart';
import 'package:hollybike/journey/type/user_journey.dart';
import 'package:hollybike/user/types/minimal_user.dart';

import 'event_participation_journey_content.dart';
import 'event_participation_journey_empty.dart';

class EventParticipationJourney extends StatelessWidget {
  final UserJourney? journey;
  final MinimalUser user;

  const EventParticipationJourney({
    super.key,
    required this.journey,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    if (journey == null) {
      return SizedBox(
        height: 80,
        child: EventParticipationJourneyEmpty(
          username: user.username,
        ),
      );
    }

    return EventParticipationJourneyContent(
      existingJourney: journey!,
      color: Theme.of(context).colorScheme.primaryContainer,
      username: user.username,
      userId: user.id,
    );
  }
}
