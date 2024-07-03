import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:hollybike/event/bloc/event_images_bloc/event_images_event.dart';
import 'package:hollybike/image/bloc/image_list_bloc.dart';
import 'package:hollybike/image/bloc/image_list_state.dart';
import 'package:hollybike/image/services/image_repository.dart';

import '../../../image/type/event_image.dart';
import '../../../shared/types/paginated_list.dart';

class EventImagesBloc extends ImageListBloc<EventImagesEvent> {
  final int numberOfImagesPerRequest = 20;

  final int eventId;
  final ImageRepository imageRepository;

  EventImagesBloc({
    required this.eventId,
    required this.imageRepository,
  }) : super(ImageListInitial()) {
    on<LoadEventImagesNextPage>(_onLoadEventImagesNextPage);
    on<RefreshEventImages>(_onRefreshEventImages);
  }

  Future<void> _onLoadEventImagesNextPage(
    LoadEventImagesNextPage event,
    Emitter<ImageListState> emit,
  ) async {
    if (state.hasMore == false || state.status == EventImagesStatus.loading) {
      return;
    }

    emit(ImageListPageLoadInProgress(state));

    try {
      PaginatedList<EventImage> page = await imageRepository.fetchEventImages(
        eventId,
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

  Future<void> _onRefreshEventImages(
    RefreshEventImages event,
    Emitter<ImageListState> emit,
  ) async {
    emit(ImageListPageLoadInProgress(state));

    try {
      PaginatedList<EventImage> page = await imageRepository.refreshEventImages(
        eventId,
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

extension FirstWhenNotLoading on EventImagesBloc {
  Future<ImageListState> get firstWhenNotLoading async {
    return stream.firstWhere((state) {
      return state is! ImageListPageLoadInProgress;
    });
  }
}
