import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../shared/widgets/loading_placeholders/gradient_loading_placeholder.dart';
import '../../../image/type/event_image.dart';

class EventImageWithLoader extends StatelessWidget {
  final EventImage image;
  final void Function()? onTap;

  const EventImageWithLoader({
    super.key,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: image.width / image.height,
      child: Stack(
        children: [
          Hero(
            tag: 'event_image_${image.id}',
            child: CachedNetworkImage(
              cacheKey: 'image_${image.id}',
              imageUrl: image.url,
              fit: BoxFit.cover,
              progressIndicatorBuilder: (context, url, downloadProgress) {
                final progress = _getProgress(
                  downloadProgress.downloaded,
                  image.size,
                );
                return AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: progress,
                  child: const GradientLoadingPlaceholder(),
                );
              },
              imageBuilder: (context, imageProvider) => Image(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
              errorWidget: (context, url, error) => const Center(
                child: Icon(
                  Icons.photo,
                  size: 48,
                  color: CupertinoColors.systemGrey,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _getProgress(int downloaded, int total) {
    if (downloaded == total) {
      return 0.2;
    } else if (downloaded == 0) {
      return 0.2;
    } else {
      return ((downloaded / total) - 1) * -1;
    }
  }
}
