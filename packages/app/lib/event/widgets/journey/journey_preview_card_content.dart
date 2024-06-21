import 'package:flutter/material.dart';
import 'package:hollybike/journey/widgets/journey_location.dart';
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
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "349km",
                    style: Theme.of(context).textTheme.titleMedium,
                    softWrap: true,
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              const Spacer(),
              _getJourneyLocation(context),
            ],
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        Expanded(
          flex: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: JourneyImage(
              loadingData: loadingPositions,
              journeyId: journey.id,
              imageUrl: journey.previewImage,
            ),
          ),
        ),
      ],
    );
  }

  Widget _getJourneyLocation(BuildContext context) {
    if (loadingPositions) {
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

    return JourneyLocation(journey: journey);
  }
}
