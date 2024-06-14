import 'package:flutter/material.dart';
import 'package:hollybike/event/types/image/event_image_details.dart';
import 'package:hollybike/event/types/minimal_event.dart';

class ImageGalleryDetailsEvent extends StatelessWidget {
  final MinimalEvent event;

  const ImageGalleryDetailsEvent({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "Event ${event.name}",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
