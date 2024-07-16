/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:flutter/material.dart';
import 'package:hollybike/shared/types/position.dart';

class ImageGalleryDetailsPosition extends StatelessWidget {
  final Position? position;

  const ImageGalleryDetailsPosition({
    super.key,
    required this.position,
  });

  @override
  Widget build(BuildContext context) {
    if (position == null) {
      return const SizedBox();
    }

    final imagePosition = position as Position;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Position.getIcon(imagePosition.positionType),
              color: Theme.of(context).colorScheme.onPrimary,
              size: 36,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _buildPosition(context, imagePosition),
            ),
          ],
        ),
      ),
    );
  }

  RichText _buildPosition(BuildContext context, Position position) {
    final preciseName = position.placeName;
    final fullCityName = position.cityName;
    final stateName = position.countyName ?? position.stateName;

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

    if (preciseName != null) {
      addSpan(TextSpan(
        text: preciseName,
        style: Theme.of(context).textTheme.titleSmall,
      ));
    }

    if (fullCityName != null) {
      addSpan(TextSpan(
        text: fullCityName,
        style: Theme.of(context).textTheme.bodySmall,
      ));
    }

    if (stateName != null) {
      addSpan(TextSpan(
        text: stateName,
        style: Theme.of(context).textTheme.bodySmall,
      ));
    }

    if (texts.isEmpty) {
      addSpan(TextSpan(
        text: "${position.latitude}, ${position.longitude}",
        style: Theme.of(context).textTheme.bodySmall,
      ));
    }

    return RichText(
      softWrap: true,
      text: TextSpan(
        children: texts,
      ),
    );
  }
}
