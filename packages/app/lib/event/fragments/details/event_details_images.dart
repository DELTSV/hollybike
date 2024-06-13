import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_images_bloc/event_images_bloc.dart';

import '../../../app/app_router.gr.dart';
import '../../../shared/utils/with_current_session.dart';
import '../../../shared/widgets/image_gallery/image_gallery.dart';
import '../../bloc/event_images_bloc/event_images_event.dart';
import '../../bloc/event_images_bloc/event_images_state.dart';

class EventDetailsImages extends StatelessWidget {
  final int eventId;
  final ScrollController scrollController;

  const EventDetailsImages({
    super.key,
    required this.eventId,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventImagesBloc, EventImagesState>(
      builder: (context, state) {
        return ImageGallery(
          scrollController: scrollController,
          onRefresh: () => _refreshImages(context),
          onLoadNextPage: () => _loadNextPage(context),
          images: state.images,
          loading: state is EventImagesPageLoadInProgress,
          onImageTap: (image) {
            context.router.push(
              EventImageViewRoute(
                imageIndex: state.images.indexOf(image),
                onLoadNextPage: () => _loadNextPage(context),
              ),
            );
          },
        );
      },
    );
  }

  void _refreshImages(BuildContext context) {
    withCurrentSession(
      context,
      (session) {
        context.read<EventImagesBloc>().add(
              RefreshEventImages(
                session: session,
                eventId: eventId,
              ),
            );
      },
    );
  }

  void _loadNextPage(BuildContext context) {
    withCurrentSession(
      context,
      (session) {
        context.read<EventImagesBloc>().add(
              LoadEventImagesNextPage(
                session: session,
                eventId: eventId,
              ),
            );
      },
    );
  }
}
