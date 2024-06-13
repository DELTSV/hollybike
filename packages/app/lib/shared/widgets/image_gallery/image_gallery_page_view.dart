import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hollybike/event/types/image/event_image.dart';
import 'package:photo_view/photo_view.dart';

class ImageGalleryPageView extends StatefulWidget {
  final int imageIndex;
  final List<EventImage> images;
  final void Function() onLoadNextPage;

  const ImageGalleryPageView({
    super.key,
    required this.imageIndex,
    required this.onLoadNextPage,
    required this.images,
  });

  @override
  State<ImageGalleryPageView> createState() => _ImageGalleryPageViewState();
}

class _ImageGalleryPageViewState extends State<ImageGalleryPageView> {
  late final controller = PageController(
    initialPage: widget.imageIndex,
  );

  late int currentPage = widget.imageIndex;

  bool isZoomed = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: (_) {
        setState(() {
          isZoomed = true;
        });
      },
      child: PageView.builder(
        onPageChanged: (index) {
          setState(() {
            currentPage = index;
          });

          if (index == widget.images.length - 1) {
            widget.onLoadNextPage();
          }
        },
        controller: controller,
        physics: isZoomed
            ? const NeverScrollableScrollPhysics()
            : const AlwaysScrollableScrollPhysics(),
        itemCount: widget.images.length,
        itemBuilder: (context, index) {
          final image = widget.images[index];

          final hero = index == currentPage
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
            gestureDetectorBehavior: HitTestBehavior.translucent,
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
