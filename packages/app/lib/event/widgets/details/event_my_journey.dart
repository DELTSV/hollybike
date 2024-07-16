/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:hollybike/event/types/event_details.dart';
import 'package:hollybike/user_journey/widgets/user_journey_card.dart';

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
    return UserJourneyCard(
      isCurrentEvent: true,
      journey: eventDetails.callerParticipation?.journey,
      color: Theme.of(context).colorScheme.primary,
    );
  }
}
