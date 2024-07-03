import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:hollybike/image/bloc/image_list_bloc.dart';
import 'package:hollybike/image/bloc/image_list_state.dart';
import 'package:hollybike/image/services/image_repository.dart';
import 'package:hollybike/image/type/event_image.dart';
import 'package:hollybike/profile/bloc/profile_image_bloc/profile_images_event.dart';
import 'package:hollybike/shared/types/paginated_list.dart';

class ProfileImagesBloc extends ImageListBloc<ProfileImagesEvent> {
  final int numberOfImagesPerRequest = 20;

  final ImageRepository imageRepository;

  ProfileImagesBloc({
    required this.imageRepository,
  }) : super(ImageListInitial()) {
    on<LoadProfileImagesNextPage>(_onLoadProfileImagesNextPage);
    on<RefreshProfileImages>(_onRefreshProfileImages);
  }

  Future<void> _onLoadProfileImagesNextPage(
    LoadProfileImagesNextPage event,
    Emitter<ImageListState> emit,
  ) async {
    if (state.hasMore == false || state.status == EventImagesStatus.loading) {
      return;
    }

    emit(ImageListPageLoadInProgress(state));

    try {
      PaginatedList<EventImage> page = await imageRepository.fetchProfileImages(
        event.userId,
        state.nextPage,
        numberOfImagesPerRequest,
      );

      emit(ImageListPageLoadSuccess(state.copyWith(
        images: [...state.images, ...page.items],
        hasMore: page.items.length == numberOfImagesPerRequest,
        nextPage: state.nextPage + 1,
      )));
    } catch (e) {
      log('Error while loading next page of images', error: e);
      emit(ImageListPageLoadFailure(
        state,
        errorMessage: 'Une erreur est survenue.',
      ));
      return;
    }
  }

  _onRefreshProfileImages(
    RefreshProfileImages event,
    Emitter<ImageListState> emit,
  ) async {
    if (event.initial) {
      emit(ImageListInitialPageLoadInProgress(state));
    } else {
      emit(ImageListPageLoadInProgress(state));
    }

    try {
      PaginatedList<EventImage> page =
      await imageRepository.refreshProfileImages(
        event.userId,
        numberOfImagesPerRequest,
      );

      emit(ImageListPageLoadSuccess(state.copyWith(
        images: page.items,
        hasMore: page.items.length == numberOfImagesPerRequest,
        nextPage: 1,
      )));
    } catch (e) {
      log('Error while refreshing images', error: e);
      emit(ImageListPageLoadFailure(
        state,
        errorMessage: 'Une erreur est survenue.',
      ));
      return;
    }
  }
}

extension FirstWhenNotLoading on ProfileImagesBloc {
  Future<ImageListState> get firstWhenNotLoading async {
    return stream.firstWhere((state) {
      return state is! ImageListPageLoadInProgress &&
          state is! ImageListInitialPageLoadInProgress;
    });
  }
}
