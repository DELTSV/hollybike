import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:hollybike/event/bloc/event_images_bloc/event_images_event.dart';
import 'package:hollybike/event/bloc/event_images_bloc/event_images_state.dart';

import '../../services/image/image_repository.dart';
import '../../types/image/event_image.dart';
import '../../../shared/types/paginated_list.dart';

class EventMyImagesBloc extends Bloc<EventImagesEvent, EventImagesState> {
  final int numberOfImagesPerRequest = 20;

  final ImageRepository imageRepository;

  EventMyImagesBloc({
    required this.imageRepository,
  }) : super(EventImagesInitial()) {
    on<LoadEventImagesNextPage>(_onLoadEventImagesNextPage);
    on<RefreshEventImages>(_onRefreshEventImages);
    on<UploadEventImages>(_onUploadEventImages);
  }

  Future<void> _onLoadEventImagesNextPage(
    LoadEventImagesNextPage event,
    Emitter<EventImagesState> emit,
  ) async {
    if (state.hasMore == false || state.status == EventImagesStatus.loading) {
      return;
    }

    emit(EventImagesPageLoadInProgress(state));

    try {
      PaginatedList<EventImage> page = await imageRepository.fetchEventImages(
        event.session,
        event.eventId,
        state.nextPage,
        numberOfImagesPerRequest,
      );

      emit(EventImagesPageLoadSuccess(state.copyWith(
        images: [...state.images, ...page.items],
        hasMore: page.items.length == numberOfImagesPerRequest,
        nextPage: state.nextPage + 1,
      )));
    } catch (e) {
      log('Error while loading next page of images', error: e);
      emit(EventImagesPageLoadFailure(
        state,
        errorMessage: 'Une erreur est survenue.',
      ));
      return;
    }
  }

  Future<void> _onRefreshEventImages(
    RefreshEventImages event,
    Emitter<EventImagesState> emit,
  ) async {
    emit(EventImagesPageLoadInProgress(state));

    try {
      PaginatedList<EventImage> page = await imageRepository.refreshEventImages(
        event.session,
        event.eventId,
        numberOfImagesPerRequest,
      );

      emit(EventImagesPageLoadSuccess(state.copyWith(
        images: page.items,
        hasMore: page.items.length == numberOfImagesPerRequest,
        nextPage: 1,
      )));
    } catch (e) {
      log('Error while refreshing images', error: e);
      emit(EventImagesPageLoadFailure(
        state,
        errorMessage: 'Une erreur est survenue.',
      ));
      return;
    }
  }

  Future<void> _onUploadEventImages(
    UploadEventImages event,
    Emitter<EventImagesState> emit,
  ) async {
    emit(EventImagesUploadInProgress(state));

    try {
      await imageRepository.uploadEventImages(
        event.session,
        event.eventId,
        event.images,
      );

      emit(EventImagesUploadSuccess(state));
    } catch (e) {
      log('Error while uploading images', error: e);
      emit(EventImagesUploadFailure(
        state,
        errorMessage: 'Une erreur est survenue.',
      ));
      return;
    }
  }
}
