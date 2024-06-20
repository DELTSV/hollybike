import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../event/types/image/event_image.dart';
import '../../../event/widgets/images/event_image_with_loader.dart';

class ImageGallery extends StatefulWidget {
  final ScrollController scrollController;
  final List<EventImage> images;
  final bool loading;
  final void Function(EventImage) onImageTap;
  final void Function() onRefresh;
  final void Function() onLoadNextPage;

  const ImageGallery({
    super.key,
    required this.scrollController,
    required this.images,
    required this.loading,
    required this.onRefresh,
    required this.onLoadNextPage,
    required this.onImageTap,
  });

  @override
  State<ImageGallery> createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<ImageGallery> {
  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
    widget.onRefresh();
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.loading) {
      return const SliverToBoxAdapter(
        child: SizedBox(
          height: 300,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.all(4),
      sliver: SliverMasonryGrid.count(
        crossAxisCount: 3,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        childCount: widget.images.length,
        itemBuilder: (context, index) {
          final image = widget.images[index];

          return EventImageWithLoader(
            image: image,
            onTap: () {
              widget.onImageTap(image);
            },
          );
        },
      ),
    );
  }

  void _onScroll() {
    var nextPageTrigger =
        0.8 * widget.scrollController.position.maxScrollExtent;

    if (widget.scrollController.position.pixels > nextPageTrigger) {
      widget.onLoadNextPage();
    }
  }
}
