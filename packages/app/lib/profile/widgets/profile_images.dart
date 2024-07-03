import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/app/app_router.gr.dart';
import 'package:hollybike/event/widgets/details/event_details_scroll_wrapper.dart';
import 'package:hollybike/image/bloc/image_list_state.dart';
import 'package:hollybike/image/widgets/image_gallery/image_gallery.dart';
import 'package:hollybike/profile/bloc/profile_image_bloc/profile_images_bloc.dart';
import 'package:hollybike/shared/widgets/loaders/themed_refresh_indicator.dart';
import 'package:lottie/lottie.dart';

import '../bloc/profile_image_bloc/profile_images_event.dart';

class ProfileImages extends StatelessWidget {
  final int userId;
  final ScrollController scrollController;

  const ProfileImages({
    super.key,
    required this.userId,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileImagesBloc, ImageListState>(
      builder: (context, state) {
        return ThemedRefreshIndicator(
          onRefresh: () => _refreshImages(context),
          child: EventDetailsTabScrollWrapper(
            sliverChild: true,
            scrollViewKey: 'profile_images',
            child: ImageGallery(
              scrollController: scrollController,
              emptyPlaceholder: _buildPlaceholder(context),
              onRefresh: () => _refreshImages(context),
              onLoadNextPage: () => _loadNextPage(context),
              images: state.images,
              loading: state is ImageListPageLoadInProgress,
              onImageTap: (image) {
                context.router.push(
                  ProfileImageViewRoute(
                    imageIndex: state.images.indexOf(image),
                    onLoadNextPage: () => _loadNextPage(context),
                    onRefresh: () => _refreshImages(context),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Lottie.asset(
          fit: BoxFit.cover,
          'assets/lottie/lottie_images_placeholder.json',
          repeat: false,
          height: 150,
        ),
        const Text(
          "Aucune image disponible",
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Future<void> _refreshImages(BuildContext context) {
    context.read<ProfileImagesBloc>().add(
      RefreshProfileImages(
        userId: userId,
      ),
    );

    return context.read<ProfileImagesBloc>().firstWhenNotLoading;
  }

  void _loadNextPage(BuildContext context) {
    context.read<ProfileImagesBloc>().add(
      LoadProfileImagesNextPage(
        userId: userId,
      ),
    );
  }
}
