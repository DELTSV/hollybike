import 'package:flutter/material.dart';
import 'package:hollybike/event/types/event.dart';

class EventImage extends StatelessWidget {
  const EventImage({super.key, required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    return event.image == null
        ? Image.asset(
      event.placeholderImage,
      fit: BoxFit.cover,
    )
        : Image.network(
      event.image!,
      fit: BoxFit.cover,
    );
  }
}
