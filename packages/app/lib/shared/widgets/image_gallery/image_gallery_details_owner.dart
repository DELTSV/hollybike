import 'package:flutter/material.dart';
import 'package:hollybike/event/types/image/event_image_details.dart';
import 'package:hollybike/event/types/minimal_event.dart';
import 'package:hollybike/user/types/minimal_user.dart';

class ImageGalleryDetailsOwner extends StatelessWidget {
  final MinimalUser owner;

  const ImageGalleryDetailsOwner({
    super.key,
    required this.owner,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "User ${owner.username}",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
