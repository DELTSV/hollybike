/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:hollybike/journey/type/minimal_journey.dart';

import 'journey_position.dart';

class JourneyLocation extends StatelessWidget {
  final double sizeFactor;
  final MinimalJourney journey;

  const JourneyLocation({
    super.key,
    required this.journey,
    this.sizeFactor = 1,
  });

  @override
  Widget build(BuildContext context) {
    final locations = <Widget>[];

    if (journey.start != null) {
      final start = JourneyPosition(pos: journey.start!, isLarge: sizeFactor > 1);

      locations.add(Row(
        children: [
          Icon(
            Icons.location_on_rounded,
            size: 16 * sizeFactor,
          ),
          SizedBox(width: 4 * sizeFactor),
          Expanded(child: start),
        ],
      ));
    }

    if (locations.isNotEmpty) {
      locations.add(SizedBox(height: 8 * sizeFactor));
    }

    if (journey.end != null) {
      final end = JourneyPosition(pos: journey.end!, isLarge: sizeFactor > 1);
      locations.add(Row(
        children: [
          Icon(
            Icons.sports_score_rounded,
            size: 16 * sizeFactor,
          ),
          SizedBox(width: 4 * sizeFactor),
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
