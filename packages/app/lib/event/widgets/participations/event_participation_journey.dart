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
    return Container(
      height: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
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
            children: addSeparators(
              [
                Row(
                  children: [
                    const Icon(
                      Icons.north_east_rounded,
                      size: 16,
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
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${existingJourney.totalElevationLoss} m',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
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
      ),
    );
  }
}
