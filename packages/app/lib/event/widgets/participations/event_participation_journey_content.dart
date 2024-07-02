import 'package:flutter/material.dart';
import 'package:hollybike/journey/type/user_journey.dart';
import 'package:hollybike/shared/utils/add_separators.dart';

class EventParticipationJourneyContent extends StatelessWidget {
  final UserJourney existingJourney;

  const EventParticipationJourneyContent({
    super.key,
    required this.existingJourney,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              existingJourney.distanceLabel,
              style: Theme.of(context).textTheme.titleMedium,
              softWrap: true,
            ),
            Text(
              existingJourney.totalTimeLabel,
              style: Theme.of(context).textTheme.bodyMedium,
              softWrap: true,
            ),
          ],
        ),
        const Spacer(),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: addSeparators(
            [
              Row(
                children: [
                  const Icon(
                    Icons.north_east_rounded,
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${existingJourney.totalElevationGain} m',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.south_east_rounded,
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${existingJourney.totalElevationLoss} m',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
            const SizedBox(height: 3),
          ),
        ),
        const SizedBox(width: 16),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: addSeparators(
            [
              Row(
                children: [
                  const Icon(
                    Icons.vertical_align_bottom_rounded,
                    size: 20,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '${existingJourney.minElevation} m',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.terrain_rounded,
                    size: 20,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '${existingJourney.maxElevation} m',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
            const SizedBox(height: 3),
          ),
        ),
        const SizedBox(width: 16),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: addSeparators(
            [
              Row(
                children: [
                  const Icon(
                    Icons.speed_rounded,
                    size: 20,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    existingJourney.maxSpeedLabel,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.speed_rounded,
                    size: 20,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    existingJourney.avgSpeedLabel,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
            const SizedBox(height: 3),
          ),
        )
      ],
    );
  }
}
