/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:hollybike/event/types/event_details.dart';
import 'package:hollybike/event/widgets/journey/journey_modal_header.dart';
import 'package:hollybike/journey/widgets/journey_image.dart';
import 'package:hollybike/journey/widgets/journey_location.dart';
import 'package:hollybike/shared/utils/add_separators.dart';

import '../../../journey/type/minimal_journey.dart';

class JourneyModal extends StatelessWidget {
  final void Function() onViewOnMap;
  final EventDetails eventDetails;

  final MinimalJourney journey;

  const JourneyModal({
    super.key,
    required this.journey,
    required this.onViewOnMap,
    required this.eventDetails,
  });

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
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              JourneyModalHeader(
                onViewOnMap: onViewOnMap,
                event: eventDetails.event,
                canEditJourney: eventDetails.canEditJourney,
              ),
              const SizedBox(height: 14),
              JourneyLocation(
                journey: journey,
                sizeFactor: 1.5,
              ),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: JourneyImage(
                  imageKey: journey.previewImageKey,
                  imageUrl: journey.previewImage,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  const Icon(
                    Icons.route_outlined,
                    size: 28,
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
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
