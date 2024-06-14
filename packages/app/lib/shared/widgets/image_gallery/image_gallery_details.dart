import 'package:flutter/material.dart';
import 'package:hollybike/event/types/image/event_image_details.dart';
import 'package:hollybike/shared/widgets/image_gallery/image_gallery_details_event.dart';
import 'package:hollybike/shared/widgets/image_gallery/image_gallery_details_owner.dart';

import 'image_gallery_details_position.dart';

class ImageGalleryDetails extends StatelessWidget {
  final EventImageDetails imageDetails;

  const ImageGalleryDetails({
    super.key,
    required this.imageDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ImageGalleryDetailsEvent(event: imageDetails.event),
        const SizedBox(height: 8),
        ImageGalleryDetailsOwner(owner: imageDetails.owner),
        const SizedBox(height: 8),
        ImageGalleryDetailsPosition(position: imageDetails.position),
      ],
    );
  }
}
