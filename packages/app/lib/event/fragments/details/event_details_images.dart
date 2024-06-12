import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hollybike/event/bloc/event_images_bloc/event_images_bloc.dart';
import 'package:hollybike/event/widgets/images/event_image_with_loader.dart';

import '../../../app/app_router.gr.dart';
import '../../../shared/utils/with_current_session.dart';
import '../../bloc/event_images_bloc/event_images_event.dart';
import '../../bloc/event_images_bloc/event_images_state.dart';

class EventDetailsImages extends StatefulWidget {
  final int eventId;
  final ScrollController scrollController;

  const EventDetailsImages({
    super.key,
    required this.eventId,
    required this.scrollController,
  });

  @override
  State<EventDetailsImages> createState() => _EventDetailsImagesState();
}

class _EventDetailsImagesState extends State<EventDetailsImages> {
  @override
  void initState() {
    super.initState();

    widget.scrollController.addListener(() {
      var nextPageTrigger =
          0.8 * widget.scrollController.position.maxScrollExtent;

      if (widget.scrollController.position.pixels > nextPageTrigger) {
        _loadNextPage(context);
      }
    });

    _refreshImages(context);
  }

  void _refreshImages(BuildContext context) {
    withCurrentSession(
      context,
      (session) {
        context.read<EventImagesBloc>().add(
              RefreshEventImages(
                session: session,
                eventId: widget.eventId,
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
                eventId: widget.eventId,
              ),
            );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventImagesBloc, EventImagesState>(
      builder: (context, state) {
        if (state is EventImagesPageLoadInProgress && state.images.isEmpty) {
          return const SliverToBoxAdapter(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.all(4),
          sliver: SliverMasonryGrid.count(
            crossAxisCount: 3,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            childCount: state.images.length,
            itemBuilder: (context, index) {
              final image = state.images[index];

              return EventImageWithLoader(image: image, onTap: () {
                context.router.push(
                  EventImageViewRoute(
                    imageIndex: index,
                    images: state.images,
                  ),
                );
              });
            },
          ),
        );
      },
    );
  }
}
