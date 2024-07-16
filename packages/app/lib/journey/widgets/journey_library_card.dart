/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:hollybike/journey/type/journey.dart';
import 'package:hollybike/journey/widgets/journey_image.dart';
import 'package:hollybike/journey/widgets/journey_location.dart';

import 'journey_metrics.dart';

class JourneyLibraryCard extends StatelessWidget {
  final Journey journey;
  final void Function(Journey) onSelected;

  const JourneyLibraryCard({
    super.key,
    required this.journey,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(
                height: 130,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            journey.name,
                            style: Theme.of(context).textTheme.titleMedium,
                            maxLines: 2,
                            softWrap: true,
                          ),
                          Expanded(
                            child: Center(
                              child: JourneyMetrics(
                                journey: journey.toMinimalJourney(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      flex: 2,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: JourneyImage(
                          imageKey: journey.previewImageKey,
                          imageUrl: journey.previewImage,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              JourneyLocation(journey: journey.toMinimalJourney())
            ],
          ),
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => onSelected(journey),
            ),
          ),
        ),
      ],
    );
  }
}
