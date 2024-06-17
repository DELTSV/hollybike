import 'package:flutter/material.dart';
import 'package:hollybike/journey/type/minimal_journey.dart';
import 'journey_position.dart';

class JourneyLocation extends StatelessWidget {
  final MinimalJourney journey;

  const JourneyLocation({
    super.key,
    required this.journey,
  });

  @override
  Widget build(BuildContext context) {
    final locations = <Widget>[];

    final start = JourneyPosition(pos: journey.start);
    if (start is! SizedBox) {
      locations.add(Row(
        children: [
          const Icon(
            Icons.location_on_rounded,
            size: 16,
          ),
          const SizedBox(width: 4),
          Expanded(child: start),
        ],
      ));
    }

    if (locations.isNotEmpty) {
      locations.add(const SizedBox(height: 8));
    }

    final end = JourneyPosition(pos: journey.end);
    if (start is! SizedBox) {
      locations.add(Row(
        children: [
          const Icon(
            Icons.sports_score_rounded,
            size: 16,
          ),
          const SizedBox(width: 4),
          Expanded(child: end),
        ],
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: locations,
    );
  }
}
