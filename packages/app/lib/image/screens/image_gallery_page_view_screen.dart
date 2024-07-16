/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_images_bloc/event_image_details_bloc.dart';
import 'package:hollybike/image/bloc/image_list_bloc.dart';
import 'package:hollybike/image/bloc/image_list_state.dart';
import 'package:hollybike/image/services/image_repository.dart';
import 'package:hollybike/image/widgets/image_gallery/image_gallery_page_view.dart';

@RoutePage()
class ImageGalleryViewScreen extends StatelessWidget
    implements AutoRouteWrapper {
  final int imageIndex;
  final void Function() onLoadNextPage;
  final void Function() onRefresh;
  final ImageListBloc bloc;

  const ImageGalleryViewScreen({
    super.key,
    required this.imageIndex,
    required this.onLoadNextPage,
    required this.onRefresh,
    required this.bloc,
  });

  @override
  Widget wrappedRoute(context) {
    return BlocProvider<EventImageDetailsBloc>(
      create: (context) => EventImageDetailsBloc(
        imageRepository: RepositoryProvider.of<ImageRepository>(
          context,
        ),
      ),
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImageListBloc, ImageListState>(
      bloc: bloc,
      builder: (context, state) => ImageGalleryPageView(
        imageIndex: imageIndex,
        images: state.images,
        onLoadNextPage: onLoadNextPage,
        onImageDeleted: onRefresh,
      ),
    );
  }
}
