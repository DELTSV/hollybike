import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/widgets/image_gallery/image_gallery_page_view.dart';
import '../../bloc/event_images_bloc/event_images_state.dart';
import '../../bloc/event_images_bloc/event_my_images_bloc.dart';

@RoutePage()
class EventMyImageViewScreen extends StatelessWidget {
  final int imageIndex;
  final void Function() onLoadNextPage;

  const EventMyImageViewScreen({
    super.key,
    required this.imageIndex,
    required this.onLoadNextPage,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventMyImagesBloc, EventImagesState>(
      builder: (context, state) => ImageGalleryPageView(
        imageIndex: imageIndex,
        images: state.images,
        onLoadNextPage: onLoadNextPage,
      ),
    );
  }
}
