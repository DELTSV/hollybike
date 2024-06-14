import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hollybike/event/types/image/event_image.dart';
import 'package:hollybike/shared/widgets/image_gallery/image_gallery_bottom_modal.dart';
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

  double _bottomContainerHeight = 0;
  final double _bottomContainerMaxHeight = 200;
  bool _animate = false;

  late int currentPage = widget.imageIndex;

  bool isZoomed = false;

  get modalOpened => _bottomContainerHeight == _bottomContainerMaxHeight;
  get modalOpening => _bottomContainerHeight > 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onModaleOpened() {
    setState(() {
      _bottomContainerHeight = _bottomContainerMaxHeight;
    });
  }

  void _onModaleClosed() {
    setState(() {
      _bottomContainerHeight = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        setState(() {
          final delta = _bottomContainerHeight - details.delta.dy;
          _bottomContainerHeight = delta.clamp(0, _bottomContainerMaxHeight);
        });
      },
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity! > 10) {
          _onModaleClosed();
        } else if (details.primaryVelocity! < -10) {
          _onModaleOpened();
        } else if (_bottomContainerHeight > _bottomContainerMaxHeight / 2) {
          _onModaleOpened();
        } else {
          _onModaleClosed();
        }

        setState(() {
          _animate = true;
        });
      },
      onVerticalDragStart: (details) {
        setState(() {
          _animate = false;
        });
      },
      child: Container(
        color: Colors.black,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Flexible(
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
            ),
            AnimatedContainer(
              duration:
                  _animate ? const Duration(milliseconds: 100) : Duration.zero,
              height: _bottomContainerHeight,
              width: double.infinity,
              child: PopScope(
                canPop: !modalOpened,
                onPopInvoked: (bool canPop) {
                  if (!canPop) {
                    _onModaleClosed();
                  }
                },
                child: modalOpening ? ImageGalleryBottomModal(
                  image: widget.images[currentPage],
                ) : const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
