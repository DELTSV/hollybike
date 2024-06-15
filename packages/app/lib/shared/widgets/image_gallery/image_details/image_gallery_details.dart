import 'package:flutter/material.dart';
import 'package:hollybike/event/types/image/event_image_details.dart';
import 'package:hollybike/shared/widgets/image_gallery/image_details/image_gallery_details_owner.dart';

import 'image_gallery_details_event.dart';
import 'image_gallery_details_position.dart';
import 'image_gallery_details_time.dart';

class ImageGalleryDetails extends StatelessWidget {
  final EventImageDetails imageDetails;

  const ImageGalleryDetails({
    super.key,
    required this.imageDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ImageGalleryDetailsOwner(owner: imageDetails.owner),
          const SizedBox(height: 16),
          ImageGalleryDetailsTime(
            uploadedAt: imageDetails.uploadDateTime,
            takenAt: imageDetails.takenDateTime,
          ),
          const SizedBox(height: 16),
          ImageGalleryDetailsEvent(event: imageDetails.event),
          const SizedBox(height: 16),
          ImageGalleryDetailsPosition(position: imageDetails.position),
        ],
      ),
    );
  }
}
