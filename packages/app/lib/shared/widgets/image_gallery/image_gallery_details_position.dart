import 'package:flutter/material.dart';
import 'package:hollybike/event/types/image/event_image_details.dart';
import 'package:hollybike/event/types/minimal_event.dart';
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

    return Row(
      children: [
        Text(
          "Position ${imagePosition.cityName}",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
