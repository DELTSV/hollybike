/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/image/type/event_image.dart';
import 'package:hollybike/image/widgets/image_gallery/image_gallery_bottom_modal.dart';
import 'package:hollybike/shared/utils/safe_set_state.dart';
import 'package:hollybike/shared/widgets/modal/content_shrink_bottom_modal.dart';
import 'package:photo_view/photo_view.dart';

import '../../../event/bloc/event_images_bloc/event_image_details_bloc.dart';
import '../../../event/bloc/event_images_bloc/event_image_details_state.dart';

class ImageGalleryPageView extends StatefulWidget {
  final int imageIndex;
  final List<EventImage> images;
  final void Function() onLoadNextPage;
  final void Function() onImageDeleted;

  const ImageGalleryPageView({
    super.key,
    required this.imageIndex,
    required this.onLoadNextPage,
    required this.images,
    required this.onImageDeleted,
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

  get currentImage {
    try {
      return widget.images[currentPage];
    } catch (e) {
      return null;
    }
  }

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
    final currentImage = this.currentImage;

    if (currentImage == null) {
      return Container(
        color: Colors.black,
      );
    }

    return BlocListener<EventImageDetailsBloc, EventImageDetailsState>(
      listener: (context, state) {
        if (state is DeleteImageSuccess) {
          _onImageDeleted();
        }
      },
      child: ContentShrinkBottomModal(
        modalOpened: modalOpened,
        onStatusChanged: (opened) {
          safeSetState(() {
            modalOpened = opened;
          });
        },
        maxModalHeight: 460,
        enableDrag: !isZoomed,
        modalContent: ImageGalleryBottomModal(
          image: widget.images[currentPage],
          onImageDeleted: () {
            setState(() {
              modalOpened = false;
            });
          },
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
                cacheKey: image.key,
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
      ),
    );
  }

  void _onImageDeleted() {
    if (currentPage < widget.images.length - 1) {
      controller.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pop();
    }

    widget.onImageDeleted();
  }
}
