/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:hollybike/journey/type/minimal_journey.dart';
import 'package:hollybike/shared/utils/add_separators.dart';

class JourneyMetrics extends StatelessWidget {
  final MinimalJourney journey;

  const JourneyMetrics({
    super.key,
    required this.journey,
  });

  @override
  Widget build(BuildContext context) {
    final metrics = <Widget>[];

    if (journey.totalDistance != null) {
      metrics.add(Row(
        children: [
          const Icon(
            Icons.route_outlined,
            size: 16,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              journey.distanceLabel,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ));
    }

    if (journey.totalElevationGain != null) {
      metrics.add(Row(
        children: [
          const Icon(
            Icons.north_east_rounded,
            size: 16,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              '${journey.totalElevationGain} m',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ));
    }

    if (journey.totalElevationLoss != null) {
      metrics.add(Row(
        children: [
          const Icon(
            Icons.south_east_rounded,
            size: 16,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              '${journey.totalElevationLoss} m',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: addSeparators(metrics, const SizedBox(height: 8)),
    );
  }
}
