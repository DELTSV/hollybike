import 'package:flutter/material.dart';
import 'package:hollybike/journey/widgets/journey_image.dart';
import 'package:hollybike/shared/utils/add_separators.dart';

import '../../../journey/type/minimal_journey.dart';

class JourneyModal extends StatelessWidget {
  final MinimalJourney journey;

  const JourneyModal({super.key, required this.journey});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(31),
          topRight: Radius.circular(31),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Supprimer le trajet'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Changer de trajet'),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: JourneyImage(
                journeyId: journey.id,
                imageUrl: journey.previewImage,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                const Icon(
                  Icons.route_outlined,
                  size: 32,
                ),
                const SizedBox(width: 8),
                Text(
                  journey.distanceLabel,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                Row(
                  children: [
                    const Icon(
                      Icons.north_east_rounded,
                      size: 20,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${journey.totalElevationGain} m',
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
                    const SizedBox(width: 5),
                    Text(
                      '${journey.totalElevationLoss} m',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: addSeparators(
                [
                  const Spacer(),
                  Row(
                    children: [
                      const Icon(
                        Icons.vertical_align_bottom_rounded,
                        size: 20,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${journey.minElevation} m',
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
                        '${journey.maxElevation} m',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
                const SizedBox(width: 8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
