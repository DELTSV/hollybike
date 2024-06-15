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
    final sections = <Widget>[
      ImageGalleryDetailsOwner(owner: imageDetails.owner),
      ImageGalleryDetailsTime(
        uploadedAt: imageDetails.uploadDateTime,
        takenAt: imageDetails.takenDateTime,
      ),
      ImageGalleryDetailsEvent(event: imageDetails.event),
      ImageGalleryDetailsPosition(position: imageDetails.position),
    ];

    final children = <Widget>[];

    for (var i = 0; i < sections.length; i++) {
      children.add(_animationWrapper(sections[i], i));

      if (i != sections.length - 1) {
        children.add(const SizedBox(height: 16));
      }
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _animationWrapper(Widget child, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      curve: Curves.ease,
      duration: Duration(milliseconds: (index * 50)),
      builder: (BuildContext context, double delayed, _) {
        if (delayed != 1) {
          return const SizedBox();
        }

        return TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          curve: Curves.ease,
          duration: const Duration(milliseconds: 300),
          builder: (BuildContext context, double value, _) {
            return Transform.translate(
              offset: Offset(16 * (1 - value), 0),
              child: Opacity(
                opacity: value,
                child: child,
              ),
            );
          },
        );
      },
    );
  }
}
