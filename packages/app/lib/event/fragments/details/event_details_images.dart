/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_images_bloc/event_images_bloc.dart';
import 'package:hollybike/image/bloc/image_list_state.dart';
import 'package:hollybike/image/widgets/image_gallery/image_gallery.dart';
import 'package:hollybike/shared/widgets/loaders/themed_refresh_indicator.dart';
import 'package:lottie/lottie.dart';

import '../../../app/app_router.gr.dart';
import '../../bloc/event_images_bloc/event_images_event.dart';
import '../../widgets/details/event_details_scroll_wrapper.dart';

class EventDetailsImages extends StatelessWidget {
  final int eventId;
  final ScrollController scrollController;
  final bool isParticipating;
  final void Function() onAddPhotos;

  const EventDetailsImages({
    super.key,
    required this.eventId,
    required this.scrollController,
    required this.isParticipating,
    required this.onAddPhotos,
  });

  @override
  Widget build(BuildContext context) {
    return ThemedRefreshIndicator(
      onRefresh: () => _refreshImages(context),
      child: BlocBuilder<EventImagesBloc, ImageListState>(
        builder: (context, state) {
          return EventDetailsTabScrollWrapper(
            sliverChild: true,
            scrollViewKey: 'event_details_images_$eventId',
            child: ImageGallery(
              scrollController: scrollController,
              emptyPlaceholder: _buildPlaceholder(),
              onRefresh: () => _refreshImages(context),
              onLoadNextPage: () => _loadNextPage(context),
              images: state.images,
              loading: state is ImageListPageLoadInProgress,
              error: state is ImageListPageLoadFailure,
              onImageTap: (image) {
                context.router.push(
                  ImageGalleryViewRoute(
                    imageIndex: state.images.indexOf(image),
                    onLoadNextPage: () => _loadNextPage(context),
                    onRefresh: () => _refreshImages(context),
                    bloc: context.read<EventImagesBloc>(),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlaceholder() {
    final widgets = <Widget>[
      Lottie.asset(
        fit: BoxFit.cover,
        'assets/lottie/lottie_images_placeholder.json',
        repeat: false,
        height: 150,
      ),
      const Text(
        "Aucune photo ajoutée sur cet évènement",
        textAlign: TextAlign.center,
      ),
    ];

    if (isParticipating) {
      widgets.addAll([
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            onAddPhotos();
          },
          child: const Text("Ajouter des photos"),
        ),
      ]);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: widgets,
    );
  }

  Future<void> _refreshImages(BuildContext context) {
    context.read<EventImagesBloc>().add(
          RefreshEventImages(),
        );

    return context.read<EventImagesBloc>().firstWhenNotLoading;
  }

  void _loadNextPage(BuildContext context) {
    context.read<EventImagesBloc>().add(
          LoadEventImagesNextPage(),
        );
  }
}
