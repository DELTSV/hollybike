/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/app/app_router.gr.dart';
import 'package:hollybike/event/widgets/details/event_details_scroll_wrapper.dart';
import 'package:hollybike/image/bloc/image_list_state.dart';
import 'package:hollybike/image/widgets/image_gallery/image_gallery.dart';
import 'package:hollybike/profile/bloc/profile_images_bloc/profile_images_bloc.dart';
import 'package:hollybike/profile/bloc/profile_images_bloc/profile_images_event.dart';
import 'package:hollybike/shared/widgets/loaders/themed_refresh_indicator.dart';
import 'package:lottie/lottie.dart';

class ProfileImages extends StatelessWidget {
  final ScrollController scrollController;
  final bool isMe;
  final String username;

  const ProfileImages({
    super.key,
    required this.scrollController,
    required this.isMe,
    required this.username,
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
              error: state is ImageListPageLoadFailure,
              onImageTap: (image) {
                context.router.push(
                  ImageGalleryViewRoute(
                    imageIndex: state.images.indexOf(image),
                    onLoadNextPage: () => _loadNextPage(context),
                    onRefresh: () => _refreshImages(context),
                    bloc: context.read<ProfileImagesBloc>(),
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
        Text(
          isMe
              ? 'Vous n\'avez pas encore ajouté d\'images'
              : '$username n\'a pas encore ajouté d\'images',
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Future<void> _refreshImages(BuildContext context) {
    context.read<ProfileImagesBloc>().add(
          RefreshProfileImages(),
        );

    return context.read<ProfileImagesBloc>().firstWhenNotLoading;
  }

  void _loadNextPage(BuildContext context) {
    context.read<ProfileImagesBloc>().add(
          LoadProfileImagesNextPage(),
        );
  }
}
