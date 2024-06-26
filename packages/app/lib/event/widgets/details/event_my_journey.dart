import 'package:flutter/material.dart';
import 'package:hollybike/event/types/event_details.dart';
import 'package:hollybike/event/widgets/participations/event_participation_journey_content.dart';

import 'event_my_empty_journey.dart';

class EventMyJourney extends StatelessWidget {
  final EventDetails eventDetails;

  const EventMyJourney({super.key, required this.eventDetails});

  @override
  Widget build(BuildContext context) {
    if (eventDetails.callerParticipation == null ||
        (eventDetails.callerParticipation?.hasRecordedPositions == false &&
            eventDetails.callerParticipation?.journey == null)) {
      return const SizedBox();
    }

    return Column(
      children: [
        const SizedBox(height: 16),
        _buildMyJourney(context),
      ],
    );
  }

  Widget _buildMyJourney(BuildContext context) {
    if (eventDetails.callerParticipation?.journey == null) {
      return const SizedBox(
        height: 70,
        child: EventMyEmptyJourney(),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: EventParticipationJourneyContent(
        existingJourney: eventDetails.callerParticipation!.journey!,
      ),
    );
  }
}
