import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:hollybike/image/bloc/image_list_state.dart';
import 'package:hollybike/image/services/image_repository.dart';

import '../../../shared/types/paginated_list.dart';
import '../../services/event/event_repository.dart';
import '../../../image/type/event_image.dart';
import 'event_my_images_event.dart';

class EventMyImagesBloc extends Bloc<EventMyImagesEvent, ImageListState> {
  final int numberOfImagesPerRequest = 20;

  final ImageRepository imageRepository;
  final EventRepository eventRepository;

  EventMyImagesBloc({
    required this.imageRepository,
    required this.eventRepository,
  }) : super(ImageListInitial()) {
    on<LoadMyEventImagesNextPage>(_onLoadMyEventImagesNextPage);
    on<RefreshMyEventImages>(_onRefreshMyEventImages);
    on<UploadEventImages>(_onUploadEventImages);
    on<UpdateImagesVisibility>(_onUpdateImagesVisibility);
  }

  Future<void> _onLoadMyEventImagesNextPage(
    LoadMyEventImagesNextPage event,
    Emitter<ImageListState> emit,
  ) async {
    if (state.hasMore == false || state.status == EventImagesStatus.loading) {
      return;
    }

    emit(ImageListPageLoadInProgress(state));

    try {
      PaginatedList<EventImage> page = await imageRepository.fetchMyEventImages(
        event.eventId,
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

  Future<void> _onRefreshMyEventImages(
    RefreshMyEventImages event,
    Emitter<ImageListState> emit,
  ) async {
    if (event.initial) {
      emit(ImageListInitialPageLoadInProgress(state));
    } else {
      emit(ImageListPageLoadInProgress(state));
    }

    try {
      PaginatedList<EventImage> page =
          await imageRepository.refreshMyEventImages(
        event.eventId,
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

  Future<void> _onUploadEventImages(
    UploadEventImages event,
    Emitter<ImageListState> emit,
  ) async {
    emit(ImageListOperationInProgress(state));

    try {
      await imageRepository.uploadEventImages(
        event.eventId,
        event.images,
      );

      emit(ImageListOperationSuccess(
        state,
        shouldRefresh: true,
        successMessage: "Photos ajoutées avec succès",
      ));
    } catch (e) {
      log('Error while uploading images', error: e);
      emit(ImageListOperationFailure(
        state,
        errorMessage: 'Une erreur est survenue.',
      ));
      return;
    }
  }

  Future<void> _onUpdateImagesVisibility(
    UpdateImagesVisibility event,
    Emitter<ImageListState> emit,
  ) async {
    emit(ImageListOperationInProgress(state));

    try {
      await imageRepository.updateImagesVisibility(
        event.eventId,
        event.isPublic,
      );

      eventRepository.onImagesVisibilityUpdated(event.isPublic, event.eventId);

      emit(ImageListOperationSuccess(state));
    } catch (e) {
      log('Error while updating images visibility', error: e);
      emit(ImageListOperationFailure(
        state,
        errorMessage: 'Une erreur est survenue.',
      ));
      return;
    }
  }
}

extension FirstWhenNotLoading on EventMyImagesBloc {
  Future<ImageListState> get firstWhenNotLoading async {
    return stream.firstWhere((state) {
      return state is! ImageListPageLoadInProgress;
    });
  }
}

