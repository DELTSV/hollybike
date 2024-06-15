import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/widgets/image_gallery/image_gallery_page_view.dart';
import '../../bloc/event_images_bloc/event_images_bloc.dart';
import '../../bloc/event_images_bloc/event_images_state.dart';

@RoutePage()
class EventImageViewScreen extends StatelessWidget {
  final int imageIndex;
  final void Function() onLoadNextPage;
  final void Function() onRefresh;

  const EventImageViewScreen({
    super.key,
    required this.imageIndex,
    required this.onLoadNextPage,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventImagesBloc, EventImagesState>(
      builder: (context, state) => ImageGalleryPageView(
        imageIndex: imageIndex,
        images: state.images,
        onLoadNextPage: onLoadNextPage,
        onImageDeleted: onRefresh,
      ),
    );
  }
}
