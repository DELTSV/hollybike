import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hollybike/event/types/image/event_image.dart';
import 'package:hollybike/shared/widgets/image_gallery/image_gallery_bottom_modal.dart';
import 'package:photo_view/photo_view.dart';

import '../modal/content_shrink_bottom_modal.dart';

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
  bool modalOpened = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ContentShrinkBottomModal(
      onStatusChanged: (opened) {
        setState(() {
          modalOpened = opened;
        });
      },
      enableDrag: !isZoomed,
      modalContent: ImageGalleryBottomModal(
        image: widget.images[currentPage],
      ),
      child: PageView.builder(
        dragStartBehavior: DragStartBehavior.down,
        onPageChanged: (index) {
          setState(() {
            currentPage = index;
          });

          if (index == widget.images.length - 1) {
            widget.onLoadNextPage();
          }
        },
        controller: controller,
        physics: isZoomed || modalOpened
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
            initialScale: PhotoViewComputedScale.contained,
            disableGestures: modalOpened,
            imageProvider: CachedNetworkImageProvider(
              image.url,
              cacheKey: 'image_${image.id}',
            ),
            gestureDetectorBehavior: HitTestBehavior.translucent,
            scaleStateChangedCallback: (scaleState) {
              setState(() {
                isZoomed = scaleState != PhotoViewScaleState.initial;
              });
            },
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
