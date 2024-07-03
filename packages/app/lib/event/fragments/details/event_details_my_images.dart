import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/widgets/details/event_details_scroll_wrapper.dart';
import 'package:hollybike/event/widgets/images/event_images_visibility_dialog.dart';
import 'package:hollybike/image/bloc/image_list_state.dart';
import 'package:hollybike/image/widgets/image_gallery/image_gallery.dart';
import 'package:hollybike/shared/widgets/loaders/themed_refresh_indicator.dart';
import 'package:lottie/lottie.dart';

import '../../../app/app_router.gr.dart';
import '../../../shared/widgets/app_toast.dart';
import '../../bloc/event_details_bloc/event_details_bloc.dart';
import '../../bloc/event_details_bloc/event_details_event.dart';
import '../../bloc/event_images_bloc/event_my_images_bloc.dart';
import '../../bloc/event_images_bloc/event_my_images_event.dart';

class EventDetailsMyImages extends StatelessWidget {
  final int eventId;
  final bool isImagesPublic;
  final bool isParticipating;
  final ScrollController scrollController;

  const EventDetailsMyImages({
    super.key,
    required this.eventId,
    required this.scrollController,
    required this.isParticipating,
    required this.isImagesPublic,
  });

  @override
  Widget build(BuildContext context) {
    return ThemedRefreshIndicator(
      onRefresh: () => _refreshImages(context),
      child: Stack(
        children: [
          BlocListener<EventMyImagesBloc, ImageListState>(
            listener: (context, state) {
              if (state is ImageListOperationFailure) {
                Toast.showErrorToast(
                  context,
                  state.errorMessage,
                );
              }

              if (state is ImageListOperationSuccess) {
                if (state.successMessage != null) {
                  Toast.showSuccessToast(
                    context,
                    state.successMessage!,
                  );
                }

                if (state.shouldRefresh) {
                  _refreshImages(context);
                }
              }
            },
            child: BlocBuilder<EventMyImagesBloc, ImageListState>(
              builder: (context, state) {
                return EventDetailsTabScrollWrapper(
                  sliverChild: true,
                  scrollViewKey: 'event_details_my_images_$eventId',
                  child: ImageGallery(
                    scrollController: scrollController,
                    emptyPlaceholder: _buildPlaceholder(context),
                    onRefresh: () => _refreshImages(context),
                    onLoadNextPage: () => _loadNextPage(context),
                    images: state.images,
                    loading: state is ImageListPageLoadInProgress,
                    onImageTap: (image) {
                      context.router.push(
                        ImageGalleryViewRoute(
                          imageIndex: state.images.indexOf(image),
                          onLoadNextPage: () => _loadNextPage(context),
                          onRefresh: () => _refreshImages(context),
                          bloc: context.read<EventMyImagesBloc>(),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          Positioned.fill(
            top: 60,
            right: 10,
            child: Align(
              alignment: Alignment.topRight,
              child: Stack(
                children: [
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.9,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: _buildVisibilityText(context),
                          ),
                          const SizedBox(width: 7),
                          _buildVisibilityIcon(context),
                        ],
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(5),
                        onTap: () {
                          showEventImagesVisibilityDialog(
                            context,
                            isImagesPublic: isImagesPublic,
                            eventId: eventId,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisibilityIcon(BuildContext context) {
    return Icon(
      isImagesPublic ? Icons.public : Icons.lock_outline,
      color: Theme.of(context).colorScheme.onPrimary,
    );
  }

  Widget _buildVisibilityText(BuildContext context) {
    return Text(
      isImagesPublic ? "Vos images sont publiques" : "Vos images sont privées",
      style: Theme.of(context)
          .textTheme
          .titleSmall
          ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    final message = isParticipating
        ? "Vous n'avez ajouté aucune photo"
        : "Vous devez participer à l'évènement ajouter des photos";

    final widgets = <Widget>[
      Lottie.asset(
        fit: BoxFit.cover,
        'assets/lottie/lottie_images_placeholder.json',
        repeat: false,
        height: 150,
      ),
      Text(
        message,
        textAlign: TextAlign.center,
      ),
    ];

    if (!isParticipating) {
      widgets.addAll([
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => _onJoin(context),
          child: const Text("Rejoindre l'évènement"),
        ),
      ]);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: widgets,
    );
  }

  Future<void> _refreshImages(BuildContext context) {
    context.read<EventMyImagesBloc>().add(
          RefreshMyEventImages(),
        );

    return context.read<EventMyImagesBloc>().firstWhenNotLoading;
  }

  void _loadNextPage(BuildContext context) {
    context.read<EventMyImagesBloc>().add(
          LoadMyEventImagesNextPage(),
        );
  }

  void _onJoin(BuildContext context) {
    context.read<EventDetailsBloc>().add(
          JoinEvent(),
        );
  }
}
