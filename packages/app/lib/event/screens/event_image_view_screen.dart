import 'package:auto_route/annotations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hollybike/images/types/event_image.dart';
import 'package:photo_view/photo_view.dart';

@RoutePage()
class EventImageViewScreen extends StatefulWidget {
  final int imageIndex;
  final List<EventImage> images;

  const EventImageViewScreen({
    super.key,
    required this.imageIndex,
    required this.images,
  });

  @override
  State<EventImageViewScreen> createState() => _EventImageViewScreenState();
}

class _EventImageViewScreenState extends State<EventImageViewScreen> {
  late final controller = PageController(
    initialPage: widget.imageIndex,
  );

  bool isZoomed = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // detect multi-touch gestures
    return GestureDetector(
      onScaleStart: (_) {
        setState(() {
          isZoomed = true;
        });
      },
      child: PageView.builder(
        controller: controller,
        physics: isZoomed
            ? const NeverScrollableScrollPhysics()
            : const AlwaysScrollableScrollPhysics(),
        itemCount: widget.images.length,
        itemBuilder: (context, index) {
          final image = widget.images[index];

          final hero = index == widget.imageIndex
              ? PhotoViewHeroAttributes(
                  tag: 'event_image_${image.id}',
                )
              : null;

          return PhotoView(
            imageProvider: CachedNetworkImageProvider(
              image.url,
              cacheKey: 'image_${image.id}',
            ),
            scaleStateChangedCallback: (scaleState) {
              setState(() {
                isZoomed = scaleState != PhotoViewScaleState.initial;
              });
            },
            gestureDetectorBehavior: HitTestBehavior.opaque,
            loadingBuilder: (context, event) {
              return Center(
                child: Container(
                  color: Colors.black,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.black,
                child: const Center(
                  child: Text(
                    'Une erreur est survenue lors du chargement de l\'image',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            },
            maxScale: PhotoViewComputedScale.covered * 2.0,
            minScale: PhotoViewComputedScale.contained,
            heroAttributes: hero,
          );
        },
      ),
    );
  }
}
