import 'package:flutter/material.dart';
import 'package:hollybike/event/types/event.dart';
import 'package:hollybike/event/widgets/journey/empty_journey_preview_card.dart';

class JourneyPreviewCard extends StatelessWidget {
  final Event event;
  final String? journey;

  const JourneyPreviewCard({
    super.key,
    required this.journey,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: _buildJourneyPreview(),
    );
  }

  Widget _buildJourneyPreview() {
    if (journey == null) {
      return EmptyJourneyPreviewCard(
          event: event,
      );
    }

    return const Placeholder();
  }
}
