import 'package:flutter/material.dart';
import 'package:hollybike/journey/widgets/journey_position.dart';
import 'package:hollybike/shared/utils/add_separators.dart';

import '../../../journey/type/minimal_journey.dart';
import '../../../journey/widgets/journey_image.dart';
import '../../../shared/widgets/loading_placeholders/text_loading_placeholder.dart';

class JourneyPreviewCardContent extends StatelessWidget {
  final MinimalJourney journey;
  final bool loadingPositions;

  const JourneyPreviewCardContent({
    super.key,
    required this.journey,
    required this.loadingPositions,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    journey.distanceLabel,
                    style: Theme.of(context).textTheme.titleMedium,
                    softWrap: true,
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              const SizedBox(height: 8),
              _getJourneyLocation(context),
            ],
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        Expanded(
          flex: 3,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: JourneyImage(
              journeyId: journey.id,
              imageUrl: journey.previewImage,
            ),
          ),
        ),
      ],
    );
  }

  Widget _getJourneyLocation(BuildContext context) {
    if (loadingPositions && journey.destination == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextLoadingPlaceholder(
            textStyle: Theme.of(context).textTheme.bodySmall,
            minLetters: 15,
            maxLetters: 17,
          ),
          const SizedBox(height: 2),
          TextLoadingPlaceholder(
            textStyle: Theme.of(context).textTheme.bodySmall,
            minLetters: 15,
            maxLetters: 17,
          ),
          const SizedBox(height: 8),
          TextLoadingPlaceholder(
            textStyle: Theme.of(context).textTheme.bodySmall,
            minLetters: 15,
            maxLetters: 17,
          ),
          const SizedBox(height: 2),
          TextLoadingPlaceholder(
            textStyle: Theme.of(context).textTheme.bodySmall,
            minLetters: 15,
            maxLetters: 17,
          ),
        ],
      );
    }

    final location = journey.readablePartialLocation;
    final start = journey.start;

    final wigets = <Widget>[];

    if (start != null) {
      wigets.add(
        Row(
          children: [
            const Icon(
              Icons.flag,
              size: 16,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: JourneyPosition(pos: start),
            ),
          ],
        ),
      );
    }

    if (location != null) {
      wigets.add(
        Row(
          children: [
            const Icon(
              Icons.location_on_sharp,
              size: 16,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                location,
                style: Theme.of(context).textTheme.bodySmall,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ],
        ),
      );
    }

    if (wigets.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: addSeparators(wigets, const SizedBox(height: 8)),
    );
  }
}
