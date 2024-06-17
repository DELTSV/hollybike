import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hollybike/journey/type/journey.dart';
import 'package:hollybike/shared/types/position.dart';

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
          height: 150,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(16),
          child: Expanded(
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
                        softWrap: true,
                      ),
                      const Spacer(),
                      ..._getLocations(context),
                    ],
                  ),
                ),
                if (journey.previewImage != null)
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    flex: 2,
                    child: Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: journey.previewImage as String,
                          cacheKey: "preview-${journey.id}",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
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

  List<Widget> _getLocations(BuildContext context) {
    final locations = <Widget>[];

    final start = _getLocationFromPosition(context, journey.start);
    if (start != null) {
      locations.add(
        Row(
          children: [
            const Icon(
              Icons.location_on_rounded,
              size: 16,
            ),
            const SizedBox(width: 4),
            Expanded(child: start),
          ],
        )
      );
    }

    if (locations.isNotEmpty) {
      locations.add(const SizedBox(height: 8));
    }

    final end = _getLocationFromPosition(context, journey.end);
    if (end != null) {
      locations.add(
        Row(
          children: [
            const Icon(
              Icons.sports_score_rounded,
              size: 16,
            ),
            const SizedBox(width: 4),
            Expanded(child: end),
          ],
        )
      );
    }

    return locations;
  }

  RichText? _getLocationFromPosition(BuildContext context, Position? pos) {
    if (pos == null) {
      return null;
    }

    final texts = <TextSpan>[];

    void addSpan(TextSpan span) {
      if (texts.isNotEmpty) {
        texts.add(
          TextSpan(
            text: ", ",
            style: Theme.of(context).textTheme.bodySmall,
          ),
        );
      }

      texts.add(span);
    }

    final countyName = pos.countyName;
    final cityName = pos.cityName;
    final countryName = pos.countryName;

    if (cityName != null) {
      addSpan(TextSpan(
        text: cityName,
        style: Theme.of(context).textTheme.bodySmall,
      ));
    }

    if (countyName != null) {
      addSpan(TextSpan(
        text: countyName,
        style: Theme.of(context).textTheme.bodySmall,
      ));
    }

    if (countryName != null && countryName != "France") {
      addSpan(TextSpan(
        text: countryName,
        style: Theme.of(context).textTheme.bodySmall,
      ));
    }

    if (texts.isEmpty) {
      return null;
    }

    return RichText(
      softWrap: true,
      text: TextSpan(
        children: texts,
      ),
    );
  }
}
