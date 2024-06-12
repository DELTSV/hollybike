import 'package:auto_route/annotations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hollybike/images/types/event_image.dart';
import 'package:photo_view/photo_view.dart';

@RoutePage()
class EventImageViewScreen extends StatelessWidget {
  final EventImage image;

  const EventImageViewScreen({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return PhotoView(
      imageProvider: CachedNetworkImageProvider(
        image.url,
        cacheKey: 'image_${image.id}',
      ),
      maxScale: PhotoViewComputedScale.covered * 2.0,
      minScale: PhotoViewComputedScale.contained,
      heroAttributes: PhotoViewHeroAttributes(
        tag: 'event_image_${image.id}',
      ),
    );
  }
}
