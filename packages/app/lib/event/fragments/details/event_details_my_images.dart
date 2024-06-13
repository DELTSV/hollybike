import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/app_router.gr.dart';
import '../../../shared/utils/with_current_session.dart';
import '../../../shared/widgets/app_toast.dart';
import '../../../shared/widgets/image_gallery/image_gallery.dart';
import '../../bloc/event_images_bloc/event_images_state.dart';
import '../../bloc/event_images_bloc/event_my_images_bloc.dart';
import '../../bloc/event_images_bloc/event_my_images_event.dart';

class EventDetailsMyImages extends StatelessWidget {
  final int eventId;
  final ScrollController scrollController;

  const EventDetailsMyImages({
    super.key,
    required this.eventId,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<EventMyImagesBloc, EventImagesState>(
      listener: (context, state) {
        if (state is EventImagesUploadFailure) {
          Toast.showErrorToast(
            context,
            state.errorMessage,
          );
        }

        if (state is EventImagesUploadSuccess) {
          Toast.showSuccessToast(
            context,
            "Photos ajoutées avec succès",
          );
          Navigator.of(context).pop();

          _refreshImages(context);
        }
      },
      child: BlocBuilder<EventMyImagesBloc, EventImagesState>(
        builder: (context, state) {
          return ImageGallery(
            scrollController: scrollController,
            onRefresh: () => _refreshImages(context),
            onLoadNextPage: () => _loadNextPage(context),
            images: state.images,
            loading: state is EventImagesPageLoadInProgress,
            onImageTap: (image) {
              context.router.push(
                EventMyImageViewRoute(
                  imageIndex: state.images.indexOf(image),
                  onLoadNextPage: () => _loadNextPage(context),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _refreshImages(BuildContext context) {
    withCurrentSession(
      context,
      (session) {
        context.read<EventMyImagesBloc>().add(
              RefreshMyEventImages(
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
        context.read<EventMyImagesBloc>().add(
              LoadMyEventImagesNextPage(
                session: session,
                eventId: eventId,
              ),
            );
      },
    );
  }
}
