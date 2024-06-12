import 'package:auto_route/annotations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view.dart';

import '../bloc/event_images_bloc/event_images_bloc.dart';
import '../bloc/event_images_bloc/event_images_state.dart';

@RoutePage()
class EventImageViewScreen extends StatefulWidget {
  final int imageIndex;
  final void Function() onLoadNextPage;

  const EventImageViewScreen({
    super.key,
    required this.imageIndex,
    required this.onLoadNextPage,
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
    return BlocBuilder<EventImagesBloc, EventImagesState>(
      builder: (context, state) {
        return GestureDetector(
          onScaleStart: (_) {
            setState(() {
              isZoomed = true;
            });
          },
          child: PageView.builder(
            onPageChanged: (index) {
              if (index == state.images.length - 1) {
                widget.onLoadNextPage();
              }
            },
            controller: controller,
            physics: isZoomed
                ? const NeverScrollableScrollPhysics()
                : const AlwaysScrollableScrollPhysics(),
            itemCount: state.images.length,
            itemBuilder: (context, index) {
              final image = state.images[index];

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
      },
    );
  }
}
