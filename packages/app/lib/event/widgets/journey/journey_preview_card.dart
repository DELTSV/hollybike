import 'package:flutter/material.dart';
import 'package:hollybike/event/widgets/journey/empty_journey_preview_card.dart';

class JourneyPreviewCard extends StatelessWidget {
  final String? journey;

  const JourneyPreviewCard({
    super.key,
    required this.journey,
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
      return const EmptyJourneyPreviewCard();
    }

    return const Placeholder();
  }
}
